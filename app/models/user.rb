class User < ActiveRecord::Base
  attr_accessible :email, :first_name, :is_active, :is_admin, :last_name, :nickname, :oauth_expires_at, :oauth_token, :provider, :total_points, :uid

  # Relationships
  has_many :user_games
  has_many :games, :through => :user_games


	def self.from_omniauth(auth)
		where(auth.slice(:provider, :uid)).first_or_initialize.tap do |user|
			user.provider = auth.provider
			user.uid = auth.uid
			user.first_name = auth.info.first_name
			user.last_name = auth.info.last_name
			user.nickname = auth.info.nickname
			user.oauth_token = auth.credentials.token
			user.oauth_expires_at = Time.at(auth.credentials.expires_at)
			user.save!
		end
	end
end
