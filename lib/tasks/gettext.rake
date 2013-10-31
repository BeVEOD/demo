desc "Update pot/po files."
task :updatepo do
  require 'gettext/utils'
  require 'config/environment'
  app_sid = APP_SID if defined?(APP_SID)
  app_sid ||= 'application'
  app_version = APP_VERSION if defined?(APP_SID)
  app_version ||= '1.0.0'
  GetText.update_pofiles(app_sid, Dir.glob("{app,lib,bin}/**/*.{rb,rhtml,erb,builder,prawn}"), "#{app_sid} #{app_version}")
end
desc "Create mo-files"
task :makemo do
  require 'gettext/utils'
  GetText.create_mofiles(true, "po", "locale")
end