Clearance.configure do |config|
  config.routes = false
  config.mailer_sender = 'no-reply@postinvoice.com.au'
  config.cookie_expiration = lambda { |c| 60.minutes.from_now.utc }
  config.allow_sign_up = false
end

Clearance::SessionsController.layout "session"
Clearance::UsersController.layout "session"
