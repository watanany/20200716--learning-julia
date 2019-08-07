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
