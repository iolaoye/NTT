require 'test_helper'

class WeathersControllerTest < ActionController::TestCase
  setup do
    @weather = weathers(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:weathers)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create weather" do
    assert_difference('Weather.count') do
      post :create, weather: { field_id: @weather.field_id, latitude: @weather.latitude, longitude: @weather.longitude, simulation_final_year: @weather.simulation_final_year, simulation_initial_year: @weather.simulation_initial_year, station_id: @weather.station_id, station_way: @weather.station_way }
    end

    assert_redirected_to weather_path(assigns(:weather))
  end

  test "should show weather" do
    get :show, id: @weather
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @weather
    assert_response :success
  end

  test "should update weather" do
    put :update, id: @weather, weather: { field_id: @weather.field_id, latitude: @weather.latitude, longitude: @weather.longitude, simulation_final_year: @weather.simulation_final_year, simulation_initial_year: @weather.simulation_initial_year, station_id: @weather.station_id, station_way: @weather.station_way }
    assert_redirected_to weather_path(assigns(:weather))
  end

  test "should destroy weather" do
    assert_difference('Weather.count', -1) do
      delete :destroy, id: @weather
    end

    assert_redirected_to weathers_path
  end
end
