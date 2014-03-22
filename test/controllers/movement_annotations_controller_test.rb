require 'test_helper'

class MovementAnnotationsControllerTest < ActionController::TestCase
  setup do
    @movement_annotation = movement_annotations(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:movement_annotations)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create movement_annotation" do
    assert_difference('MovementAnnotation.count') do
      post :create, movement_annotation: { description: @movement_annotation.description, format: @movement_annotation.format, name: @movement_annotation.name }
    end

    assert_redirected_to movement_annotation_path(assigns(:movement_annotation))
  end

  test "should show movement_annotation" do
    get :show, id: @movement_annotation
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @movement_annotation
    assert_response :success
  end

  test "should update movement_annotation" do
    patch :update, id: @movement_annotation, movement_annotation: { description: @movement_annotation.description, format: @movement_annotation.format, name: @movement_annotation.name }
    assert_redirected_to movement_annotation_path(assigns(:movement_annotation))
  end

  test "should destroy movement_annotation" do
    assert_difference('MovementAnnotation.count', -1) do
      delete :destroy, id: @movement_annotation
    end

    assert_redirected_to movement_annotations_path
  end
end
