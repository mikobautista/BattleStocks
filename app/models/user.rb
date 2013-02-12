class User < ActiveRecord::Base
  attr_accessible :email, :is_active, :is_admin, :name, :oauth_expires_at, :oauth_token, :provider, :total_points, :uid

  # Relationships
  has_many :user_games
  has_many :games, :through => :user_games


	def self.from_omniauth(auth)
		where(auth.slice(:provider, :uid)).first_or_initialize.tap do |user|
			user.provider = auth.provider
			user.uid = auth.uid
			user.name = auth.info.name
			user.oauth_token = auth.credentials.token
			user.oauth_expires_at = Time.at(auth.credentials.expires_at)
			user.save!
		end
	end

end
