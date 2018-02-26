require 'selenium-webdriver'
require 'auto_click'
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

sleep(10)
mouse_move(400,600)
sleep(1)
mouse_move(400,400)
sleep(1)
mouse_move(500,400)
sleep(1)
mouse_move(500,600)

driver.find_element(:partial_link_text, 'Nutrient Tracking Tool').click
driver.find_element(:partial_link_text, 'Last Modified').click
driver.find_element(:partial_link_text, 'Last Modified').click
driver.find_element(:id,"stest project description").click
driver.switch_to.alert.accept()

#run simulation
driver.find_element(:id, "11-30 test copy").find_element(:link, "11-30 test copy").click
driver.find_element(:id, "field 1").find_element(:link, "field 1").click
driver.find_element(:link, "Management Scenarios").click
driver.find_element(:id, "scenario").find_element(:name, "select_scenario[]").click
driver.find_element(:id, "simulate_scenario").click
driver.find_element(:partial_link_text, 'Nutrient Tracking Tool').click
