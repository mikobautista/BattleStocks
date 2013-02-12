OmniAuth.config.logger = Rails.logger

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook, '237065239764058', '09dcd767c6aa3e4b3ba5c6b29d5ec886',
  	:scope => 'email,user_birthday,user_location' 

end