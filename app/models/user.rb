class User < ActiveRecord::Base
  attr_accessible :email, :password, :password_confirmation, :username, :total_points, :is_admin, :is_active, :password_hash, :password_salt
  attr_accessor :password

  # Callbacks
  # -----------------------------
  before_save :encrypt_password

  # Relationships
  # -----------------------------
  has_many :user_games
  has_many :games, :through => :user_games
  
  # Validations
  # -----------------------------
  # password must be present and at least 4 characters long, with a confirmation
  validates_presence_of :password, :on => :create
  validates_confirmation_of :password
  validates_length_of :password, :minimum => 4, :allow_blank => true

  # email must be unique and in proper format
  validates_presence_of :email
  validates_uniqueness_of :email
  validates_format_of :email, :with => /^[-a-z0-9_+\.]+\@([-a-z0-9]+\.)+[a-z0-9]{2,4}$/i

  #Scopes
  # -----------------------------
  scope :alphabetical, order('username')
  scope :active, where('is_active = ?', true)
  
  # Authentication Functions
  # -----------------------------
  def self.authenticate(email, password)
    user = find_by_email(email)
    if user && user.password_hash == BCrypt::Engine.hash_secret(password, user.password_salt)
      user
    else
      nil
    end
  end
  def encrypt_password
    if password.present?
      self.password_salt = BCrypt::Engine.generate_salt
      self.password_hash = BCrypt::Engine.hash_secret(password, password_salt)
    end
  end
end