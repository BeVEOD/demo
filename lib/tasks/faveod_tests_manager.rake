namespace :faveod do
  namespace :db do
    namespace :test do
      desc "Clone DB, structure and Data"
      task :clone => :environment do
        # rake db:test:clone
       dev_db = ActiveRecord::Base.configurations['development']['database']
       test_db = ActiveRecord::Base.configurations['test']['database']
       raise "Configuration Error!" if dev_db == test_db
       my_cnx = ActiveRecord::Base.establish_connection(:test).connection

       my_cnx.execute("SHOW TABLES from #{dev_db};").each do |res|
         res = res.first if ActiveRecord::Base.configurations['development']['adapter'] == 'mysql2'
         my_cnx.execute("DROP TABLE #{test_db}.#{res};")
         my_cnx.execute("CREATE TABLE IF NOT EXISTS #{test_db}.#{res} LIKE #{dev_db}.#{res};")
#   puts("Copying #{dev_db}.#{res} to #{test_db}.#{res}")
	 my_cnx.execute("INSERT INTO #{test_db}.#{res} SELECT * FROM #{dev_db}.#{res};")
	end
      end


    end
  
  end

end