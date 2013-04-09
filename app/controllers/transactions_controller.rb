class TransactionsController < ApplicationController
  # GET /transactions
  # GET /transactions.json
  def index
    @transactions = Transaction.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @transactions }
    end
  end

  # GET /transactions/1
  # GET /transactions/1.json
  def show
    @transaction = Transaction.find(params[:id])
    @user = @transaction.purchased_stock.user_game.user
    @game = @transaction.purchased_stock.user_game.game
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @transaction }
    end
  end

  # GET /transactions/new
  # GET /transactions/new.json
  def new
    @transaction = Transaction.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @transaction }
    end
  end

  # GET /transactions/1/edit
  def edit
    @transaction = Transaction.find(params[:id])
  end

  # POST /transactions
  # POST /transactions.json
  def create
    # within time bounds
    if true#(14 <= DateTime.now.hour or (13 <= DateTime.now.hour and DateTime.now.minute >= 30))
      # and (DateTime.now.hour <= 20)
      # and (DateTime.now.wday != 0 or DateTime.now.wday != 6)
      
      # create purchased_stock
      @user_game = current_user.user_games.find_by_game_id(params[:transaction][:game_id])
      @purchase = @user_game.purchased_stocks.find_or_create_by_stock_code!(params[:transaction][:stock_code].upcase)

      # create transaction & link to purchased_stock
      @transaction = Transaction.new(params[:transaction])
      @transaction.purchased_stock = @purchase
      @transaction.date = DateTime.now

      respond_to do |format|
        if @transaction.save
          @purchase.save
          format.html { redirect_to @user_game.game, notice: 'Transaction was successfully created.' }
          format.json { render json: @transaction, status: :created, location: @transaction }
        else
          format.html { render action: "new" }
          format.json { render json: @transaction.errors, status: :unprocessable_entity }
        end
      end
    # not within time bounds
    else
      redirect_to root_url
    end

  end

  # PUT /transactions/1
  # PUT /transactions/1.json
  def update
    @transaction = Transaction.find(params[:id])

    respond_to do |format|
      if @transaction.update_attributes(params[:transaction])
        format.html { redirect_to @transaction, notice: 'Transaction was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @transaction.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /transactions/1
  # DELETE /transactions/1.json
  def destroy
    @transaction = Transaction.find(params[:id])
    @transaction.destroy

    respond_to do |format|
      format.html { redirect_to transactions_url }
      format.json { head :no_content }
    end
  end
end
