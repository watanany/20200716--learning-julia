using PyCall
# pyimport_conda("selenium", "selenium")
const webdriver = pyimport("selenium.webdriver")


browser = webdriver.Chrome(executable_path="./bin/chromedriver")
browser.get("https://www.yahoo.co.jp")
sleep(2)
browser.quit()
