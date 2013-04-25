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

  def check_login
    redirect_to log_in_url, alert: "You need to log in to view this page." if current_user.nil?
  end

  rescue_from CanCan::AccessDenied do |exception|
    flash[:error] = "You are not authorized to access this page. Further, your IP address has been recorded and dispatched to the FBI, as you have just violated the Online Protection and Enforcement of Digital Trade Act"
    redirect_to root_url
  end

end
