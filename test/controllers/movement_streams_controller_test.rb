require 'test_helper'

class MovementStreamsControllerTest < ActionController::TestCase
  setup do
    @movement_stream = movement_streams(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:movement_streams)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create movement_stream" do
    assert_difference('MovementStream.count') do
      post :create, movement_stream: { description: @movement_stream.description, name: @movement_stream.name }
    end

    assert_redirected_to movement_stream_path(assigns(:movement_stream))
  end

  test "should show movement_stream" do
    get :show, id: @movement_stream
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @movement_stream
    assert_response :success
  end

  test "should update movement_stream" do
    patch :update, id: @movement_stream, movement_stream: { description: @movement_stream.description, name: @movement_stream.name }
    assert_redirected_to movement_stream_path(assigns(:movement_stream))
  end

  test "should destroy movement_stream" do
    assert_difference('MovementStream.count', -1) do
      delete :destroy, id: @movement_stream
    end

    assert_redirected_to movement_streams_path
  end
end
