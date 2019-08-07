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
