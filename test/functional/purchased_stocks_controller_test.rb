require 'test_helper'

class PurchasedStocksControllerTest < ActionController::TestCase
  setup do
    @purchased_stock = purchased_stocks(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:purchased_stocks)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create purchased_stock" do
    assert_difference('PurchasedStock.count') do
      post :create, purchased_stock: { money_earned: @purchased_stock.money_earned, money_spent: @purchased_stock.money_spent, stock_code: @purchased_stock.stock_code, total_qty: @purchased_stock.total_qty, user_game_id: @purchased_stock.user_game_id, value_in_stocks: @purchased_stock.value_in_stocks }
    end

    assert_redirected_to purchased_stock_path(assigns(:purchased_stock))
  end

  test "should show purchased_stock" do
    get :show, id: @purchased_stock
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @purchased_stock
    assert_response :success
  end

  test "should update purchased_stock" do
    put :update, id: @purchased_stock, purchased_stock: { money_earned: @purchased_stock.money_earned, money_spent: @purchased_stock.money_spent, stock_code: @purchased_stock.stock_code, total_qty: @purchased_stock.total_qty, user_game_id: @purchased_stock.user_game_id, value_in_stocks: @purchased_stock.value_in_stocks }
    assert_redirected_to purchased_stock_path(assigns(:purchased_stock))
  end

  test "should destroy purchased_stock" do
    assert_difference('PurchasedStock.count', -1) do
      delete :destroy, id: @purchased_stock
    end

    assert_redirected_to purchased_stocks_path
  end
end
