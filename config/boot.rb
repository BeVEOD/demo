if !File.exists?(File.expand_path("../../Gemfile", __FILE__))
  require './config/boot2'
else
  if defined?(RAILS_GEM_VERSION) && RAILS_GEM_VERSION =~ /\A2/
    require File.expand_path("../boot2", __FILE__)
  elsif File.exists?(File.expand_path('config/static_settings.yml', __FILE__)) && require('yaml') && YAML.load(File.open('config/static_settings.yml', 'r'))['RAILS_GEM_VERSION'] =~ /\A2/
    require './config/boot2'
  elsif File.read(File.expand_path("../../Gemfile", __FILE__)) =~ /'rails', '2/
    require './config/boot2'
  else
    require './config/boot3'
  end
end
