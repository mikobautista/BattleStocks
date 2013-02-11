class PurchasedStocksController < ApplicationController
  # GET /purchased_stocks
  # GET /purchased_stocks.json
  def index
    @purchased_stocks = PurchasedStock.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @purchased_stocks }
    end
  end

  # GET /purchased_stocks/1
  # GET /purchased_stocks/1.json
  def show
    @purchased_stock = PurchasedStock.find(params[:id])

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
end
