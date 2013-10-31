# encoding: utf-8
# Be sure to restart your web server when you modify this file.
# Uncomment below to force Rails into production mode when you don't control web/app server and can't set it the proper way
# ENV['RAILS_ENV'] ||= 'production'

if File.exists?(File.join(File.dirname(__FILE__), '..', 'tmp', 'restart.txt'))
  tmp_restart_ctn = File.read(File.join(File.dirname(__FILE__), '..', 'tmp', 'restart.txt'))
  ENV['RAILS_ENV'] = tmp_restart_ctn if tmp_restart_ctn == 'development' || tmp_restart_ctn == 'production'
end


# Bootstrap the Rails environment, frameworks, and default configuration


APP_SID = 'demo' unless defined?(APP_SID)
require File.expand_path('../application', __FILE__)

# Initialize the rails application

DemoApp::Application.initialize!


# Add new mime types for use in respond_to blocks:
# Mime::Type.register "text/richtext", :rtf
# Mime::Type.register "application/x-mobile", :mobile

Mime::Type.register("application/pdf", :pdf) unless Mime.const_defined?('PDF')


# Include your application configuration below
