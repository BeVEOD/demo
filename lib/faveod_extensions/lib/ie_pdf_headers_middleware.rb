module Faveod
class IePdfHeadersMiddleware
  def initialize(app)
    @app = app
  end

  def call(env)
    if env["PATH_INFO"] =~ /\.pdf\Z/ && env['HTTP_USER_AGENT'] && env['HTTP_USER_AGENT'][/MSIE/]
      status, headers, response = @app.call(env)
      headers.delete('Set-Cookie')
      headers.delete('Cache-Control')
      headers.delete('Content-Disposition')
      headers.delete('Pragma')
      headers.delete('X-Runtime')
      headers['Content-type'] = 'application/pdf'
      [status, headers, response]
    else
      @app.call(env)
    end
  end
end
end

if RAILS_GEM_VERSION < '3.0'
  ActionController::Dispatcher.middleware.insert_after 'Rack::Head', Faveod::IePdfHeadersMiddleware
else
  Rails.application.config.middleware.use Faveod::IePdfHeadersMiddleware
end
