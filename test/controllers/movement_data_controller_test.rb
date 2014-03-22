require 'test_helper'

class MovementDataControllerTest < ActionController::TestCase
  setup do
    @movement_datum = movement_data(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:movement_data)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create movement_datum" do
    assert_difference('MovementDatum.count') do
      post :create, movement_datum: { description: @movement_datum.description, format: @movement_datum.format, name: @movement_datum.name }
    end

    assert_redirected_to movement_datum_path(assigns(:movement_datum))
  end

  test "should show movement_datum" do
    get :show, id: @movement_datum
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @movement_datum
    assert_response :success
  end

  test "should update movement_datum" do
    patch :update, id: @movement_datum, movement_datum: { description: @movement_datum.description, format: @movement_datum.format, name: @movement_datum.name }
    assert_redirected_to movement_datum_path(assigns(:movement_datum))
  end

  test "should destroy movement_datum" do
    assert_difference('MovementDatum.count', -1) do
      delete :destroy, id: @movement_datum
    end

    assert_redirected_to movement_data_path
  end
end
