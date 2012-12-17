require 'test_helper'

class IdeaStatusesControllerTest < ActionController::TestCase
  setup do
    @idea_status = idea_statuses(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:idea_statuses)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create idea_status" do
    assert_difference('IdeaStatus.count') do
      post :create, idea_status: @idea_status.attributes
    end

    assert_redirected_to idea_status_path(assigns(:idea_status))
  end

  test "should show idea_status" do
    get :show, id: @idea_status.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @idea_status.to_param
    assert_response :success
  end

  test "should update idea_status" do
    put :update, id: @idea_status.to_param, idea_status: @idea_status.attributes
    assert_redirected_to idea_status_path(assigns(:idea_status))
  end

  test "should destroy idea_status" do
    assert_difference('IdeaStatus.count', -1) do
      delete :destroy, id: @idea_status.to_param
    end

    assert_redirected_to idea_statuses_path
  end
end
