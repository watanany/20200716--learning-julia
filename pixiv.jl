module Pixiv
    module Types
        using PyCall: pyimport, PyObject

        const webdriver = pyimport("selenium.webdriver")

        struct ClientConfig
            pixiv_id::String
            password::String
        end

        struct Client
            config::ClientConfig
            driver::PyObject

            function Client(config)
                driver = webdriver.Chrome()
                new(config, driver)
            end
        end
    end

    module Urls
        module Auths
            function login()::String
                "https://accounts.pixiv.net/login"
            end
        end

        module Bookmarks
            using Printf: @sprintf

            function index(page::Int)::String
                @sprintf("http://www.pixiv.net/bookmark.php?rest=show&p=%d", page)
            end
        end
    end

    module Auths
        using ..Types: Client
        using ..Urls

        function login!(cli::Client)
            cli.driver.get(Urls.Auths.login())
            login_form = cli.driver.find_element_by_css_selector("div#container-login form")
            login_form.find_element_by_css_selector("input[type=text]").send_keys(cli.config.pixiv_id)
            login_form.find_element_by_css_selector("input[type=password]").send_keys(cli.config.password)
            login_form.submit()
        end
    end

    module Bookmarks
        using ..Types: Client
        using ..Urls

        const NUM_ILLUSTS_PER_PAGE = 4 * 5
        const COOLDOWN = 1

        function count_index!(cli::Client)::Int
            num_bookmarks = count!(cli)
            num_bookmark_index = 0
            num_bookmark_index += div(num_bookmarks, NUM_ILLUSTS_PER_PAGE)
            num_bookmark_index += mod(num_bookmarks,  NUM_ILLUSTS_PER_PAGE)
            num_bookmark_index
        end

        function count!(cli::Client)::Int
            cli.driver.get(Urls.Bookmark.index(1))
            pat = r"\((\d+)\)"
            text = cli.driver.find_element_by_css_selector("a.bookmark-tag-all").get_attribute("innerHTML")
            m = match(pat, text)
            parse(Int, m.captures[1])
        end

        function editlinks!(cli::Client)::Set{String}
            links = Set()
            urls = [Urls.Bookmarks.index(page) for page in 1:count_index!(cli)]
            for url in urls
                cli.driver.get(url)
                anchors = cli.driver.find_elements_by_css_selector("a.edit-work")
                hrefs = Set(a.get_attribute("href") for a in anchors)
                links = union(links, hrefs)
            end
            links
        end

        function autotag!(cli::Client)::Nothing
            links = editlinks!(cli)
            for (i, link) in enumerate(links)
                cli.driver.get(link)
                α = Set(e.get_attribute("data-tag") for e in cli.driver.find_elements_by_css_selector("section.work-tags-container span[data-tag]"))
                β = Set(e.get_attribute("innerText") for e in cli.driver.find_elements_by_css_selector("section.tag-cloud-container span.tag"))
                γ = intersect(α, β)
                if length(γ) != 0
                    form = cli.driver.find_element_by_css_selector("section.bookmark-detail-unit form")
                    form_input = form.find_element_by_css_selector("input[name=tag]")
                    form_input.clear()
                    form_input.send_keys(join(γ, " "))
                    form.submit()
                    sleep(COOLDOWN)
                else
                    sleep(COOLDOWN)
                end
            end
        end
    end
end


function main()::Nothing
    config = Pixiv.Types.ClientConfig(ENV["PIXIV_ID"], ENV["PIXIV_PASSWORD"])
    cli = Pixiv.Types.Client(config)
    Pixiv.Auths.login!(cli)
    sleep(3)
    Pixiv.Bookmarks.autotag!(cli)
end


main()
