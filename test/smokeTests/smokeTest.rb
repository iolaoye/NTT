require 'selenium-webdriver'
Selenium::WebDriver::Chrome.driver_path="chromedriver.exe"
driver = Selenium::WebDriver.for :chrome
driver.get("http://localhost:3000/")

#login
driver.find_element(:id, "email").clear
driver.find_element(:id, "email").send_keys "preston.ward@go.tarleton.edu"
driver.find_element(:id, "password").clear
driver.find_element(:id, "password").send_keys "tSu123!!!"
driver.find_element(:name, "commit").click

#Create and delete project
driver.find_element(:id, "new_project").click
driver.find_element(:id, "project_name").clear
driver.find_element(:id, "project_name").send_keys "stest"
driver.find_element(:id, "project_description").clear
driver.find_element(:id, "project_description").send_keys "stest project description"
driver.find_element(:name, "commit").click
#driver.find_element(:class=>"col-sm-3 col-md-3").text.include? "stest"
driver.find_element(:partial_link_text, 'Nutrient Tracking Tool').click
driver.find_element(:partial_link_text, 'Last Modified').click
driver.find_element(:partial_link_text, 'Last Modified').click
driver.find_element(:id,"stest project description").click
driver.switch_to.alert.accept()
