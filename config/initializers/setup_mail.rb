config.action_mailer.delivery_method = :smtp
config.action_mailer.raise_delivery_errors = true
config.action_mailer.perform_deliveries = true
config.action_mailer.smtp_settings = {
  address: 'smtp.sendgrid.net',
  port: 587,
  domain: 'waybacktogovt.org',
  authentication: :plain,
  user_name: 'apikey', # Use 'apikey' as the username for SendGrid
  password: ENV['SENDGRID_API_KEY'], # API key stored in Heroku ENV variables
  enable_starttls_auto: true
}
config.action_mailer.default_url_options = { host: 'waybacktogovt.org' }