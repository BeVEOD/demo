# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require 'yaml'
ss_file = File.expand_path('../config/static_settings.yml', __FILE__)
GSS = File.exists?(ss_file) ? YAML.load(File.open(ss_file, 'r')) : {}

if GSS['RAILS_GEM_VERSION'] !~ /\A2/
   require File.expand_path('../config/application', __FILE__)
   require 'rake'

   Rails.application.load_tasks
else
  require(File.join(File.dirname(__FILE__), 'config', 'boot'))

  require 'rake'
  require 'rake/dsl_definition'
  require 'rake/testtask'
  require 'rdoc/task'

  require 'tasks/rails'
end