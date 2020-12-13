Rails.application.config.generators do |g|
  # g.stylesheets false　ページのデザインはブートストラップだけじゃなくてCSSでもやるからstylesheetは残しておく
  g.javascripts false
  g.helper false
  g.skip_routes true
end
