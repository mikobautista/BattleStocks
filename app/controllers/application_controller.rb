class ApplicationController < ActionController::Base
  protect_from_forgery
  include ActionView::Helpers::NumberHelper

	private
	def current_user
		@current_user ||= User.find(session[:user_id]) if session[:user_id]
	end
	helper_method :current_user

	def logged_in?
  		current_user
 	end
  	helper_method :logged_in?
	
	rescue_from ActiveRecord::RecordNotFound do |variable|
		flash[:notice] = "Nice Try, Prof. H. -- Qapla'!"
		redirect_to :root
	end
end
