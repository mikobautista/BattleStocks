class Game < ActiveRecord::Base
  attr_accessible :budget, :end_date, :is_terminated, :manager_id, :name, :start_date, :winner_id, :user_games

  # Relationships
  # -----------------------------
  has_many :invitations
  has_many :user_games
  has_many :users, :through => :user_games
  
  # Validations
  # -----------------------------
  validates_numericality_of :budget, :greater_than => 0
  validates_format_of :name, :with => /.+/, :message => "name cannot be blank"
  validates_date :start_date, :on_or_after => lambda { Time.now.to_date}, :message => "start date must start today onwards", :on => :create
  validates_date :end_date, :on_or_after => :start_date, :message => "end date must be on or after start date"
  validates_presence_of :budget
  validates_presence_of :end_date
  validates_presence_of :start_date
  validates_presence_of :name
  
  # Callbacks
  # -----------------------------
  before_create :dollars_to_cents
  before_create :convert_to_edt_create
  before_update :convert_to_edt_update

  # Scope
  # -----------------------------
  scope :for_user, lambda { |x| joins(:user_games).where("user_id = ?", x) }
  scope :ongoing, where('is_terminated = ?', false)
  scope :current, where('start_date <= ?', Time.now).where('end_date > ?', Time.now).where('is_terminated = ?', false)
  scope :upcoming, where('start_date > ?', Time.now).where('is_terminated = ?', false)
  scope :past, where('end_date <= ?', Time.now)
  scope :ending_soonest, order('end_date, start_date')
  scope :starting_soonest, order('start_date, end_date')
  scope :most_recent, order('end_date DESC, start_date DESC')

  # Methods
  # -----------------------------
  def dollars_to_cents
  	self.budget *= 100
  end

  # convert to est for calendar date inputs (does not take care of daylight savings)
  def convert_to_edt_create
    self.start_date += 14400
    self.end_date += 100799
  end

  def convert_to_edt_update
    self.start_date += 14400/2
    self.end_date += ((14400*3) + (14400/2) - 1)
  end

  # updates all games whose end date has passed
  def self.end_if_finished
    require 'yahoo_stock'
    for game in Game.all
      # mark all games as finished
      if game.end_date < DateTime.now and game.winner_id.nil?
        
        # sell all stocks
        for purchase in PurchasedStock.nonzero.for_game(game.id)
          value = ((YahooStock::Quote.new(:stock_symbols => [purchase.stock_code]).results(:to_array).output[0][1].to_f) * 100).to_i
          transaction = Transaction.create!(:purchased_stock_id => purchase.id, :date => DateTime.now,
            :qty => purchase.total_qty, :value_per_stock => value, :is_buy => false)
          transaction.flush_purchased_stock_and_user_game
        end

        # update winner_id
        game.winner_id = UserGame.for_game(game.id).by_portfolio_value.first.user_id
        game.save!

        # update points all user_game's points and user's total_points
        for user_game in UserGame.for_game(game.id)
          user_game.points = UserGame.for_game(game.id).size - user_game.get_rank
          user_game.user.total_points += user_game.points
          user_game.user.save!
          user_game.save!
        end
      end

    end
  end
end
