require 'selenium-webdriver'
require 'auto_click'
Selenium::WebDriver::Chrome.driver_path="chromedriver.exe"
driver = Selenium::WebDriver.for :chrome
driver.get("http://localhost:3000")
wait = Selenium::WebDriver::Wait.new(:timeout => 15000)
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
sleep(3)

driver.switch_to.frame("locationFrame")
#stateselect
dropDownMenuStateSelect = driver.find_element(:id, 'stateselect')
optionStateSelect = Selenium::WebDriver::Support::Select.new(dropDownMenuStateSelect)
begin
  optionStateSelect.select_by(:text, 'Texas')
rescue
  puts 'State selected'
end
#countyselect
dropDownMenuCountySelect = driver.find_element(:id, 'countyselect')
optionCountySelect = Selenium::WebDriver::Support::Select.new(dropDownMenuCountySelect)
begin
  optionCountySelect.select_by(:text, 'Erath')
rescue
  puts 'County selected'
end
mouse_move(575,290)
sleep(3)
left_click
mouse_move(100,300)
sleep(1)
mouse_scroll(-10)
sleep(1)
mouse_move(760, 650)
sleep(1)
$i = 0
$num = 37
begin
   left_click
   $i +=1
end while $i < $num
sleep(1)
mouse_move(500, 450)
left_click
sleep(1)
mouse_move(550, 450)
left_click
sleep(1)
mouse_move(550, 500)
left_click
sleep(1)
mouse_move(500, 500)
left_click
sleep(1)
mouse_move(500, 450)
left_click
sleep(1)
driver.switch_to.alert.accept()
sleep(1)
driver.find_element(:name, "submit").click
sleep(1)
wait.until {
  driver.find_element(:partial_link_text, 'AOI0').click
  break
}
wait.until {
  driver.find_element(:name, 'commit').click
  break
}
wait.until {
  driver.find_element(:id, 'new_scenario').click
  break
}
driver.find_element(:id, "scenario_name").clear
driver.find_element(:id, "scenario_name").send_keys "scenario test"
driver.find_element(:name, 'commit').click
wait.until {
  driver.find_element(:id, 'new_crop').click
  break
}

cropMenuSelect = driver.find_element(:id, 'cropping_system_id')
cropSelect = Selenium::WebDriver::Support::Select.new(cropMenuSelect)
begin
  cropSelect.select_by(:text, 'Corn')
rescue
  puts 'Corn selected'
end

tillageMenuSelect = driver.find_element(:id, 'tillage_id')
tillageSelect = Selenium::WebDriver::Support::Select.new(tillageMenuSelect)
begin
  tillageSelect.select_by(:text, 'Reduced (Low)')
rescue
  puts 'Tillage selected'
end
driver.find_element(:id, "upload").click
driver.find_element(:id, "continue").click
driver.find_element(:id, "select_1").click
sleep(1)
driver.find_element(:id, "bmp_cb1_1").click

irrMenuSelect = driver.find_element(:id, 'bmp_ai_irrigation_id')
irrSelect = Selenium::WebDriver::Support::Select.new(irrMenuSelect)
begin
  irrSelect.select_by(:text, 'Sprinkler')
rescue
  puts 'Irregation selected'
end
mouse_scroll(-10)
sleep(1)
driver.find_element(:name, "button").click
driver.find_element(:id, "select_scenario_").click
driver.find_element(:id, "simulate_scenario").click
driver.find_element(:partial_link_text, 'Nutrient Tracking Tool').click
driver.find_element(:partial_link_text, 'Last Modified').click
driver.find_element(:partial_link_text, 'Last Modified').click
sleep(1)
driver.find_element(:id,"stest project description").click
sleep(1)
driver.switch_to.alert.accept()
sleep(2)
puts 'Test finished no errors'
