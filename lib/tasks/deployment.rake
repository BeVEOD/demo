require "zip/zipfilesystem"
require "securerandom"

namespace :deploy do
  desc "Create a zip archive containing the application"
  task :zip => :environment do
    app_name  = Rails.application.class.parent_name.gsub(/App/, '').tableize.singularize
    timestamp = Time.now.strftime("%Y%m%d%H%M%S")
    path      = Rails.root.join("tmp", "#{app_name}_#{timestamp}.zip")

    # Perform pre-zipping tasks
    Rake::Task['db:dump'].invoke
    Rake::Task['db:dump'].reenable
    #Rake::Task['faveod:dump_access_data'].invoke
    #Rake::Task['faveod:dump_access_data'].reenable
    #Rake::Task['makemo'].invoke
    #Rake::Task['makemo'].reenable

    # Create zip
    Zip::ZipFile.open(path, Zip::ZipFile::CREATE) do |zip|
      Dir['app', 'lib', 'config', 'config.ru', 'db', 'files', 'Gemfile', 'locale', 'po', 'public', 'Rakefile', 'script', 'test'].each do |path|
        if File.directory?(path)
          zip_directory(path, zip)
        else
          zip.add(path, path)
        end
      end
      zip_directory('vendor/plugins/faveod_extensions', zip)
      zip.mkdir('tmp')
      zip.mkdir('log')
      zip.get_output_stream("log/session.secret") { |f| f.puts SecureRandom.hex(64) }
    end
  end

  def zip_directory(directory, zip)
    zip.mkdir(directory)
    Dir.glob("#{directory}/*").each do |path|
      if File.directory?(path) && !File.lstat(path).symlink?
        zip_directory(path, zip)
      else
        zip.add(path, path)
      end
    end
  end
end
