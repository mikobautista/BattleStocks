class UserGamesController < ApplicationController
  # GET /user_games
  # GET /user_games.json
  
  authorize_resource
  
  def index
    @user_games = UserGame.by_balance.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @user_games }
    end
  end

  # GET /user_games/1
  # GET /user_games/1.json
  def show
    @user_game = UserGame.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @user_game }
    end
  end

  # GET /user_games/new
  # GET /user_games/new.json
  def new
    @user_game = UserGame.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @user_game }
    end
  end

  # GET /user_games/1/edit
  def edit
    @user_game = UserGame.find(params[:id])
  end

  # POST /user_games
  # POST /user_games.json
  def create
    if params[:user_id]
      params[:user_id].each do |user_id|
        @user_game = UserGame.new(params[:user_game])
        @user_game.game_id = params[:user_game][:game_id]
        @user_game.balance = params[:user_game][:balance]
        @user_game.user_id = user_id
        @user_game.save
      end
    end

    redirect_to Game.find(params[:user_game][:game_id]), notice: 'User game was successfully created.'
    # respond_to do |format|
    #   if @user_game.save

    #     format.html { redirect_to @user_game.game, notice: 'User game was successfully created.' }
    #     format.json { render json: @user_game, status: :created, location: @user_game }
    #   else
    #     format.html { render action: "new" }
    #     format.json { render json: @user_game.errors, status: :unprocessable_entity }
    #   end
    # end
  end

  # PUT /user_games/1
  # PUT /user_games/1.json
  def update
    @user_game = UserGame.find(params[:id])

    respond_to do |format|
      if @user_game.update_attributes(params[:user_game])
        format.html { redirect_to @user_game, notice: 'User game was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @user_game.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /user_games/1
  # DELETE /user_games/1.json
  def destroy
    @user_game = UserGame.find(params[:id])
    @user_game.destroy

    respond_to do |format|
      format.html { redirect_to user_games_url }
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
