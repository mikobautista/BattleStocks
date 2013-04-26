class PurchasedStocksController < ApplicationController
  # GET /purchased_stocks
  # GET /purchased_stocks.json
  
  authorize_resource
  
  def index
    # @purchased_stocks = PurchasedStock.all
    # if logged_in?
    #   @owned_stock = PurchasedStock.nonzero_cost_basis.for_user(current_user).paginate(:page => params[:owned_stock_page]).per_page(10)
    # end

    #current owned stock
    if logged_in?
      @current_user_game_owned = UserGame.current.for_user(current_user)
      @current_owned_stock_array = []
      if ! @current_user_game_owned.empty?
        for ugame in @current_user_game_owned
          @current_owned_stock = PurchasedStock.for_user_game(ugame).nonzero
          for stock in @current_owned_stock
            @current_owned_stock_array += [[ugame.game, stock.stock_code, stock.total_qty, stock.money_spent, stock.value_in_stocks, stock.money_earned]]
          end
        end
      end
    end

    #past owned stock
    if logged_in?
      @past_user_game_owned = UserGame.past.for_user(current_user)
      @past_owned_stock_array = []
      if ! @past_user_game_owned.empty?
        for ugame in @past_user_game_owned
          @past_owned_stock = PurchasedStock.for_user_game(ugame).nonzero
          for stock in @past_owned_stock
            @past_owned_stock_array += [[ugame.game, stock.stock_code, stock.total_qty, stock.money_spent, stock.value_in_stocks, stock.money_earned]]
          end
        end
      end
    end

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @purchased_stocks }
    end
  end

  # GET /purchased_stocks/1
  # GET /purchased_stocks/1.json
  def show
    @purchased_stock = PurchasedStock.find(params[:id])
    # update purchased_stock's value_in_stocks
    current_value_in_stocks = 0 
    if (@purchased_stock.total_qty > 0)
      new_value = ((YahooStock::Quote.new(:stock_symbols => [@purchased_stock.stock_code]).results(:to_array).output[0][1].to_f) * 100).to_i
    end
    @purchased_stock.value_in_stocks = new_value * @purchased_stock.total_qty

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @purchased_stock }
    end
  end

  def show_stock
    @purchased_stock = PurchasedStock.find(params[:id])
    # update purchased_stock's value_in_stocks
    current_value_in_stocks = 0 
    if (@purchased_stock.total_qty > 0)
      new_value = ((YahooStock::Quote.new(:stock_symbols => [@purchased_stock.stock_code]).results(:to_array).output[0][1].to_f) * 100).to_i
    end
    @purchased_stock.value_in_stocks = new_value * @purchased_stock.total_qty

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @purchased_stock }
    end
  end

  # GET /purchased_stocks/new
  # GET /purchased_stocks/new.json
  def new
    @purchased_stock = PurchasedStock.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @purchased_stock }
    end
  end

  # GET /purchased_stocks/1/edit
  def edit
    @purchased_stock = PurchasedStock.find(params[:id])
  end

  # POST /purchased_stocks
  # POST /purchased_stocks.json
  def create
    @purchased_stock = PurchasedStock.new(params[:purchased_stock])

    respond_to do |format|
      if @purchased_stock.save
        format.html { redirect_to @purchased_stock, notice: 'Purchased stock was successfully created.' }
        format.json { render json: @purchased_stock, status: :created, location: @purchased_stock }
      else
        format.html { render action: "new" }
        format.json { render json: @purchased_stock.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /purchased_stocks/1
  # PUT /purchased_stocks/1.json
  def update
    @purchased_stock = PurchasedStock.find(params[:id])

    respond_to do |format|
      if @purchased_stock.update_attributes(params[:purchased_stock])
        format.html { redirect_to @purchased_stock, notice: 'Purchased stock was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @purchased_stock.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /purchased_stocks/1
  # DELETE /purchased_stocks/1.json
  def destroy
    @purchased_stock = PurchasedStock.find(params[:id])
    @purchased_stock.destroy

    respond_to do |format|
      format.html { redirect_to purchased_stocks_url }
      format.json { head :no_content }
    end
  end
  
  before_filter :require_login

  private

  def require_login
    unless logged_in?
      flash[:error] = "You must be logged in to access this section"
      redirect_to log_in_url # halts request cycle
    end
  end
end
