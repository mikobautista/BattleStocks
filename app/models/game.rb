class Game < ActiveRecord::Base
  attr_accessible :budget, :end_date, :is_terminated, :manager_id, :name, :start_date, :winner_id

  # Relationships
  has_many :invitations
  has_many :user_games
  has_many :users, :through => :user_games

  # Callbacks
  # -----------------------------
  before_create :dollars_to_cents
  before_create :convert_to_est

  # Scope
  # -----------------------------
  scope :for_user, lambda { |x| joins(:user_games).where("user_id = ?", x) }
  scope :ongoing, where('is_terminated = ?', false)

  def dollars_to_cents
  	self.budget *= 100
  end

  # convert to est for calendar date inputs (does not take care of daylight savings)
  def convert_to_est
    self.start_date += 14400
    self.end_date += 100799
  end

  # updates all games whose end date has passed
  def self.end_if_finished
    require 'yahoo_stock'
    for game in Game.all
      # mark all games as finished
      if game.end_date < DateTime.now

        game.is_terminated = true

        # sell all stocks
        for purchase in PurchasedStock.for_game(game.id)
          if (purchase.total_qty > 0)
            value = ((YahooStock::Quote.new(:stock_symbols => [purchase.stock_code]).results(:to_array).output[0][1].to_f) * 100).to_i
            transaction = Transaction.create(:purchased_stock_id => purchase.id, :date => DateTime.now,
              :qty => purchase.total_qty, :value_per_stock => value, :is_buy => false)
            transaction.save!
            purchase.save!
          end
        end

        # update winner_id
        game.winner_id = UserGame.for_game(game.id).by_balance.first.user_id

        # update points all user_game's points
        count = UserGame.for_game(game.id).size - 1
        for user_game in UserGame.for_game(game.id).by_balance
          user_game.points = count
          count -= 1
          user_game.save!
        end

      game.save!
      end

    end
  end
end
