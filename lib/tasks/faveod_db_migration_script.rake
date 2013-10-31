# encoding: utf-8
namespace :faveod do

  desc "Dump accesses, profiles and profile_accesses"
  task :dump_access_data => :environment do
    ProfileAccess.all.reject{|pa| pa.access }.each(&:destroy)
    f = File.new(Rails.root.join('db', 'profile_accesses.yml'), 'w')
    YamlDb::Dump.dump_table(f, 'profiles')
    YamlDb::Dump.dump_table(f, 'accesses')
    YamlDb::Dump.dump_table(f, 'profile_accesses')
    f.close
  end

  desc "Load accesses, profiles and profile_accesses"
  task :load_access_data => :environment do
    f = File.new(Rails.root.join('db', 'profile_accesses.yml'), 'r')
    ActiveRecord::Base.connection.transaction do
       YAML.load_documents(f) do |ydoc|
           %w(accesses profiles profile_accesses).each do |table_name|
                next if ydoc[table_name].nil?
                YamlDb::Load.load_table(table_name, ydoc[table_name])
           end
       end
    end
    f.close
  end

  desc "Add Tables and Fields in the DB"
  task :add_tables_and_fields, [:indexes, :constraints] => :environment do |t,args|
    add_indexes = args && args[:indexes]
    add_constraints = args && args[:constraints] && defined?(Foreigner)
    db_conn = ActiveRecord::Base.connection

# Maveoc: Customers, table: customers
    if !db_conn.tables.include?('customers')
      db_conn.create_table :customers do |t|
        t.column(:first_name, :string, :limit => 255)
        t.column(:last_name, :string, :limit => 255)
        t.column(:user_id, :integer)
        t.column(:new_date, :date)
        t.column(:new_string, :string, :limit => 255)
        t.column(:photo__name, :string)
      end
      puts("New Table customers Added (7 Fields)")
    else # table detected
      field_names = Customer.columns.map(&:name)

      if !field_names.include?('first_name')
        db_conn.add_column('customers', :first_name, :string, :limit => 255)
        puts("first_name (string) added to customers")
      end

      if !field_names.include?('last_name')
        db_conn.add_column('customers', :last_name, :string, :limit => 255)
        puts("last_name (string) added to customers")
      end

      if !field_names.include?('user_id')
        db_conn.add_column('customers', :user_id, :integer)
        puts("user_id (integer) added to customers")
      end

      if !field_names.include?('new_date')
        db_conn.add_column('customers', :new_date, :date)
        puts("new_date (date) added to customers")
      end

      if !field_names.include?('new_string')
        db_conn.add_column('customers', :new_string, :string, :limit => 255)
        puts("new_string (string) added to customers")
      end

      if !field_names.include?('photo__name')
        db_conn.add_column('customers', :photo__name, :string)
        puts("photo__name (string) added to customers")
      end


# Add Uniq constraints

    if add_constraints
      begin
        db_conn.add_index(:customers, :last_name, :unique => true)
        puts("Uniq constraint added to customers.last_name")
      rescue => e
      end
    end

    end


# Maveoc: System Settings, table: system_settings
    if !db_conn.tables.include?('system_settings')
      db_conn.create_table :system_settings do |t|
        t.column(:name, :string, :limit => 255)
        t.column(:value, :text)
      end
      puts("New Table system_settings Added (3 Fields)")
    else # table detected
      field_names = SystemSetting.columns.map(&:name)

      if !field_names.include?('name')
        db_conn.add_column('system_settings', :name, :string, :limit => 255)
        puts("name (string) added to system_settings")
      end

      if !field_names.include?('value')
        db_conn.add_column('system_settings', :value, :text)
        puts("value (text) added to system_settings")
      end


# Add Uniq constraints

    end


# Maveoc: Accesses, table: accesses
    if !db_conn.tables.include?('accesses')
      db_conn.create_table :accesses do |t|
        t.column(:app_sid, :string, :limit => 100)
        t.column(:set_sid, :string, :limit => 50)
        t.column(:table_sid, :string, :limit => 255)
        t.column(:field_sid, :string, :limit => 80)
        t.column(:action_sid, :string, :limit => 60)
        t.column(:type_sid, :string, :limit => 20)
      end
      puts("New Table accesses Added (7 Fields)")
    else # table detected
      field_names = Access.columns.map(&:name)

      if !field_names.include?('app_sid')
        db_conn.add_column('accesses', :app_sid, :string, :limit => 100)
        puts("app_sid (string) added to accesses")
      end

      if !field_names.include?('set_sid')
        db_conn.add_column('accesses', :set_sid, :string, :limit => 50)
        puts("set_sid (string) added to accesses")
      end

      if !field_names.include?('table_sid')
        db_conn.add_column('accesses', :table_sid, :string, :limit => 255)
        puts("table_sid (string) added to accesses")
      end

      if !field_names.include?('field_sid')
        db_conn.add_column('accesses', :field_sid, :string, :limit => 80)
        puts("field_sid (string) added to accesses")
      end

      if !field_names.include?('action_sid')
        db_conn.add_column('accesses', :action_sid, :string, :limit => 60)
        puts("action_sid (string) added to accesses")
      end

      if !field_names.include?('type_sid')
        db_conn.add_column('accesses', :type_sid, :string, :limit => 20)
        puts("type_sid (string) added to accesses")
      end


# Add Uniq constraints

    if add_constraints
      begin
        db_conn.add_index(:accesses, [:field_sid, :":table_sid"], :unique => true)
        puts("Uniq constraint added to accesses.field_sid")
      rescue => e
      end
    end

    if add_constraints
      begin
        db_conn.add_index(:accesses, [:action_sid, :":table_sid"], :unique => true)
        puts("Uniq constraint added to accesses.action_sid")
      rescue => e
      end
    end

    end


# Maveoc: Profile Accesses, table: profile_accesses
    if !db_conn.tables.include?('profile_accesses')
      db_conn.create_table :profile_accesses do |t|
        t.column(:profile_id, :integer)
        t.column(:access_id, :integer)
        t.column(:read, :boolean)
        t.column(:write, :boolean)
      end
      puts("New Table profile_accesses Added (5 Fields)")
    else # table detected
      field_names = ProfileAccess.columns.map(&:name)

      if !field_names.include?('profile_id')
        db_conn.add_column('profile_accesses', :profile_id, :integer)
        puts("profile_id (integer) added to profile_accesses")
      end

      if !field_names.include?('access_id')
        db_conn.add_column('profile_accesses', :access_id, :integer)
        puts("access_id (integer) added to profile_accesses")
      end

      if !field_names.include?('read')
        db_conn.add_column('profile_accesses', :read, :boolean)
        puts("read (boolean) added to profile_accesses")
      end

      if !field_names.include?('write')
        db_conn.add_column('profile_accesses', :write, :boolean)
        puts("write (boolean) added to profile_accesses")
      end


# Add Uniq constraints

    end


# Maveoc: User Accesses, table: user_accesses
    if !db_conn.tables.include?('user_accesses')
      db_conn.create_table :user_accesses do |t|
        t.column(:user_id, :integer)
        t.column(:access_id, :integer)
        t.column(:read, :boolean)
        t.column(:write, :boolean)
      end
      puts("New Table user_accesses Added (5 Fields)")
    else # table detected
      field_names = UserAccess.columns.map(&:name)

      if !field_names.include?('user_id')
        db_conn.add_column('user_accesses', :user_id, :integer)
        puts("user_id (integer) added to user_accesses")
      end

      if !field_names.include?('access_id')
        db_conn.add_column('user_accesses', :access_id, :integer)
        puts("access_id (integer) added to user_accesses")
      end

      if !field_names.include?('read')
        db_conn.add_column('user_accesses', :read, :boolean)
        puts("read (boolean) added to user_accesses")
      end

      if !field_names.include?('write')
        db_conn.add_column('user_accesses', :write, :boolean)
        puts("write (boolean) added to user_accesses")
      end


# Add Uniq constraints

    end


# Maveoc: Profiles, table: profiles
    if !db_conn.tables.include?('profiles')
      db_conn.create_table :profiles do |t|
        t.column(:name, :string, :limit => 100)
        t.column(:home_page_id, :integer)
      end
      puts("New Table profiles Added (3 Fields)")
    else # table detected
      field_names = Profile.columns.map(&:name)

      if !field_names.include?('name')
        db_conn.add_column('profiles', :name, :string, :limit => 100)
        puts("name (string) added to profiles")
      end

      if !field_names.include?('home_page_id')
        db_conn.add_column('profiles', :home_page_id, :integer)
        puts("home_page_id (integer) added to profiles")
      end


# Add Uniq constraints

    if add_constraints
      begin
        db_conn.add_index(:profiles, :name, :unique => true)
        puts("Uniq constraint added to profiles.name")
      rescue => e
      end
    end

    end


# Maveoc: Users, table: users
    if !db_conn.tables.include?('users')
      db_conn.create_table :users do |t|
        t.column(:login, :string, :limit => 255)
        t.column(:first_name, :string, :limit => 255)
        t.column(:last_name, :string, :limit => 255)
        t.column(:email, :string, :limit => 255)
        t.column(:telephone, :string, :limit => 255)
        t.column(:language, :string, :limit => 255)
        t.column(:active, :boolean)
        t.column(:hashed_password, :string, :limit => 255)
        t.column(:salt, :string, :limit => 255)
        t.column(:last_login, :datetime)
        t.column(:last_session_id, :string, :limit => 255)
      end
      puts("New Table users Added (12 Fields)")
    else # table detected
      field_names = User.columns.map(&:name)

      if !field_names.include?('login')
        db_conn.add_column('users', :login, :string, :limit => 255)
        puts("login (string) added to users")
      end

      if !field_names.include?('first_name')
        db_conn.add_column('users', :first_name, :string, :limit => 255)
        puts("first_name (string) added to users")
      end

      if !field_names.include?('last_name')
        db_conn.add_column('users', :last_name, :string, :limit => 255)
        puts("last_name (string) added to users")
      end

      if !field_names.include?('email')
        db_conn.add_column('users', :email, :string, :limit => 255)
        puts("email (string) added to users")
      end

      if !field_names.include?('telephone')
        db_conn.add_column('users', :telephone, :string, :limit => 255)
        puts("telephone (string) added to users")
      end

      if !field_names.include?('language')
        db_conn.add_column('users', :language, :string, :limit => 255)
        puts("language (string) added to users")
      end

      if !field_names.include?('active')
        db_conn.add_column('users', :active, :boolean)
        puts("active (boolean) added to users")
      end

      if !field_names.include?('hashed_password')
        db_conn.add_column('users', :hashed_password, :string, :limit => 255)
        puts("hashed_password (string) added to users")
      end

      if !field_names.include?('salt')
        db_conn.add_column('users', :salt, :string, :limit => 255)
        puts("salt (string) added to users")
      end

      if !field_names.include?('last_login')
        db_conn.add_column('users', :last_login, :datetime)
        puts("last_login (datetime) added to users")
      end

      if !field_names.include?('last_session_id')
        db_conn.add_column('users', :last_session_id, :string, :limit => 255)
        puts("last_session_id (string) added to users")
      end


# Add Uniq constraints

    if add_constraints
      begin
        db_conn.add_index(:users, :login, :unique => true)
        puts("Uniq constraint added to users.login")
      rescue => e
      end
    end

    end


# Maveoc: Application Locales, table: app_locales
    if !db_conn.tables.include?('app_locales')
      db_conn.create_table :app_locales do |t|
        t.column(:locale_code, :string, :limit => 255)
        t.column(:updated_at, :datetime)
        t.column(:po__name, :string)
      end
      puts("New Table app_locales Added (4 Fields)")
    else # table detected
      field_names = AppLocale.columns.map(&:name)

      if !field_names.include?('locale_code')
        db_conn.add_column('app_locales', :locale_code, :string, :limit => 255)
        puts("locale_code (string) added to app_locales")
      end

      if !field_names.include?('updated_at')
        db_conn.add_column('app_locales', :updated_at, :datetime)
        puts("updated_at (datetime) added to app_locales")
      end

      if !field_names.include?('po__name')
        db_conn.add_column('app_locales', :po__name, :string)
        puts("po__name (string) added to app_locales")
      end


# Add Uniq constraints

    if add_constraints
      begin
        db_conn.add_index(:app_locales, :locale_code, :unique => true)
        puts("Uniq constraint added to app_locales.locale_code")
      rescue => e
      end
    end

    end


# Maveoc: Background Workers, table: bg_workers
    if !db_conn.tables.include?('bg_workers')
      db_conn.create_table :bg_workers do |t|
        t.column(:every, :string)
        t.column(:from, :datetime)
        t.column(:cron, :string, :limit => 255)
        t.column(:triggered_by, :integer)
        t.column(:no_duplicate, :boolean)
        t.column(:name, :string, :limit => 255)
        t.column(:priority, :integer)
        t.column(:planned_at, :datetime)
        t.column(:created_at, :datetime)
        t.column(:started_at, :datetime)
        t.column(:locked_at, :datetime)
        t.column(:locked_by, :string, :limit => 255)
        t.column(:completed_at, :datetime)
        t.column(:last_return_code, :integer)
        t.column(:attempts, :integer)
        t.column(:failed_at, :datetime)
        t.column(:logs, :text)
      end
      puts("New Table bg_workers Added (18 Fields)")
    else # table detected
      field_names = BgWorker.columns.map(&:name)

      if !field_names.include?('every')
        db_conn.add_column('bg_workers', :every, :string)
        puts("every (string) added to bg_workers")
      end

      if !field_names.include?('from')
        db_conn.add_column('bg_workers', :from, :datetime)
        puts("from (datetime) added to bg_workers")
      end

      if !field_names.include?('cron')
        db_conn.add_column('bg_workers', :cron, :string, :limit => 255)
        puts("cron (string) added to bg_workers")
      end

      if !field_names.include?('triggered_by')
        db_conn.add_column('bg_workers', :triggered_by, :integer)
        puts("triggered_by (integer) added to bg_workers")
      end

      if !field_names.include?('no_duplicate')
        db_conn.add_column('bg_workers', :no_duplicate, :boolean)
        puts("no_duplicate (boolean) added to bg_workers")
      end

      if !field_names.include?('name')
        db_conn.add_column('bg_workers', :name, :string, :limit => 255)
        puts("name (string) added to bg_workers")
      end

      if !field_names.include?('priority')
        db_conn.add_column('bg_workers', :priority, :integer)
        puts("priority (integer) added to bg_workers")
      end

      if !field_names.include?('planned_at')
        db_conn.add_column('bg_workers', :planned_at, :datetime)
        puts("planned_at (datetime) added to bg_workers")
      end

      if !field_names.include?('created_at')
        db_conn.add_column('bg_workers', :created_at, :datetime)
        puts("created_at (datetime) added to bg_workers")
      end

      if !field_names.include?('started_at')
        db_conn.add_column('bg_workers', :started_at, :datetime)
        puts("started_at (datetime) added to bg_workers")
      end

      if !field_names.include?('locked_at')
        db_conn.add_column('bg_workers', :locked_at, :datetime)
        puts("locked_at (datetime) added to bg_workers")
      end

      if !field_names.include?('locked_by')
        db_conn.add_column('bg_workers', :locked_by, :string, :limit => 255)
        puts("locked_by (string) added to bg_workers")
      end

      if !field_names.include?('completed_at')
        db_conn.add_column('bg_workers', :completed_at, :datetime)
        puts("completed_at (datetime) added to bg_workers")
      end

      if !field_names.include?('last_return_code')
        db_conn.add_column('bg_workers', :last_return_code, :integer)
        puts("last_return_code (integer) added to bg_workers")
      end

      if !field_names.include?('attempts')
        db_conn.add_column('bg_workers', :attempts, :integer)
        puts("attempts (integer) added to bg_workers")
      end

      if !field_names.include?('failed_at')
        db_conn.add_column('bg_workers', :failed_at, :datetime)
        puts("failed_at (datetime) added to bg_workers")
      end

      if !field_names.include?('logs')
        db_conn.add_column('bg_workers', :logs, :text)
        puts("logs (text) added to bg_workers")
      end


# Add Uniq constraints

    end


# Maveoc: Smart Queries, table: smart_queries
    if !db_conn.tables.include?('smart_queries')
      db_conn.create_table :smart_queries do |t|
        t.column(:name, :string, :limit => 255)
        t.column(:table_sid, :string, :limit => 255)
        t.column(:joining_criteria, :integer)
        t.column(:criteria, :text)
      end
      puts("New Table smart_queries Added (5 Fields)")
    else # table detected
      field_names = SmartQuery.columns.map(&:name)

      if !field_names.include?('name')
        db_conn.add_column('smart_queries', :name, :string, :limit => 255)
        puts("name (string) added to smart_queries")
      end

      if !field_names.include?('table_sid')
        db_conn.add_column('smart_queries', :table_sid, :string, :limit => 255)
        puts("table_sid (string) added to smart_queries")
      end

      if !field_names.include?('joining_criteria')
        db_conn.add_column('smart_queries', :joining_criteria, :integer)
        puts("joining_criteria (integer) added to smart_queries")
      end

      if !field_names.include?('criteria')
        db_conn.add_column('smart_queries', :criteria, :text)
        puts("criteria (text) added to smart_queries")
      end


# Add Uniq constraints

    end


# Maveoc: Saved Reports, table: saved_reports
    if !db_conn.tables.include?('saved_reports')
      db_conn.create_table :saved_reports do |t|
        t.column(:name, :string, :limit => 255)
        t.column(:created_at, :datetime)
        t.column(:url, :string, :limit => 255)
        t.column(:data, :text)
      end
      puts("New Table saved_reports Added (5 Fields)")
    else # table detected
      field_names = SavedReport.columns.map(&:name)

      if !field_names.include?('name')
        db_conn.add_column('saved_reports', :name, :string, :limit => 255)
        puts("name (string) added to saved_reports")
      end

      if !field_names.include?('created_at')
        db_conn.add_column('saved_reports', :created_at, :datetime)
        puts("created_at (datetime) added to saved_reports")
      end

      if !field_names.include?('url')
        db_conn.add_column('saved_reports', :url, :string, :limit => 255)
        puts("url (string) added to saved_reports")
      end

      if !field_names.include?('data')
        db_conn.add_column('saved_reports', :data, :text)
        puts("data (text) added to saved_reports")
      end


# Add Uniq constraints

    end


# Maveoc: Uncatched Exceptions, table: uncatched_exceptions
    if !db_conn.tables.include?('uncatched_exceptions')
      db_conn.create_table :uncatched_exceptions do |t|
        t.column(:exception_class, :string, :limit => 255)
        t.column(:controller_name, :string, :limit => 255)
        t.column(:action_name, :string, :limit => 255)
        t.column(:message, :text)
        t.column(:backtrace, :text)
        t.column(:environment, :text)
        t.column(:request, :text)
        t.column(:created_at, :datetime)
      end
      puts("New Table uncatched_exceptions Added (9 Fields)")
    else # table detected
      field_names = UncatchedException.columns.map(&:name)

      if !field_names.include?('exception_class')
        db_conn.add_column('uncatched_exceptions', :exception_class, :string, :limit => 255)
        puts("exception_class (string) added to uncatched_exceptions")
      end

      if !field_names.include?('controller_name')
        db_conn.add_column('uncatched_exceptions', :controller_name, :string, :limit => 255)
        puts("controller_name (string) added to uncatched_exceptions")
      end

      if !field_names.include?('action_name')
        db_conn.add_column('uncatched_exceptions', :action_name, :string, :limit => 255)
        puts("action_name (string) added to uncatched_exceptions")
      end

      if !field_names.include?('message')
        db_conn.add_column('uncatched_exceptions', :message, :text)
        puts("message (text) added to uncatched_exceptions")
      end

      if !field_names.include?('backtrace')
        db_conn.add_column('uncatched_exceptions', :backtrace, :text)
        puts("backtrace (text) added to uncatched_exceptions")
      end

      if !field_names.include?('environment')
        db_conn.add_column('uncatched_exceptions', :environment, :text)
        puts("environment (text) added to uncatched_exceptions")
      end

      if !field_names.include?('request')
        db_conn.add_column('uncatched_exceptions', :request, :text)
        puts("request (text) added to uncatched_exceptions")
      end

      if !field_names.include?('created_at')
        db_conn.add_column('uncatched_exceptions', :created_at, :datetime)
        puts("created_at (datetime) added to uncatched_exceptions")
      end


# Add Uniq constraints

    end


# Maveoc: File Imports, table: file_imports
    if !db_conn.tables.include?('file_imports')
      db_conn.create_table :file_imports do |t|
        t.column(:user_id, :integer)
        t.column(:file_import_id, :integer)
        t.column(:started_at, :datetime)
        t.column(:completed_at, :datetime)
        t.column(:read_lines, :integer)
        t.column(:wrote_records, :integer)
        t.column(:expected_total, :integer)
        t.column(:error_count, :integer)
        t.column(:log, :text)
        t.column(:file__name, :string)
      end
      puts("New Table file_imports Added (11 Fields)")
    else # table detected
      field_names = FileImport.columns.map(&:name)

      if !field_names.include?('user_id')
        db_conn.add_column('file_imports', :user_id, :integer)
        puts("user_id (integer) added to file_imports")
      end

      if !field_names.include?('file_import_id')
        db_conn.add_column('file_imports', :file_import_id, :integer)
        puts("file_import_id (integer) added to file_imports")
      end

      if !field_names.include?('started_at')
        db_conn.add_column('file_imports', :started_at, :datetime)
        puts("started_at (datetime) added to file_imports")
      end

      if !field_names.include?('completed_at')
        db_conn.add_column('file_imports', :completed_at, :datetime)
        puts("completed_at (datetime) added to file_imports")
      end

      if !field_names.include?('read_lines')
        db_conn.add_column('file_imports', :read_lines, :integer)
        puts("read_lines (integer) added to file_imports")
      end

      if !field_names.include?('wrote_records')
        db_conn.add_column('file_imports', :wrote_records, :integer)
        puts("wrote_records (integer) added to file_imports")
      end

      if !field_names.include?('expected_total')
        db_conn.add_column('file_imports', :expected_total, :integer)
        puts("expected_total (integer) added to file_imports")
      end

      if !field_names.include?('error_count')
        db_conn.add_column('file_imports', :error_count, :integer)
        puts("error_count (integer) added to file_imports")
      end

      if !field_names.include?('log')
        db_conn.add_column('file_imports', :log, :text)
        puts("log (text) added to file_imports")
      end

      if !field_names.include?('file__name')
        db_conn.add_column('file_imports', :file__name, :string)
        puts("file__name (string) added to file_imports")
      end


# Add Uniq constraints

    end


# Maveoc: Dev Feedbacks, table: dev_feedbacks
    if !db_conn.tables.include?('dev_feedbacks')
      db_conn.create_table :dev_feedbacks do |t|
        t.column(:ticket_status, :integer)
        t.column(:title, :string, :limit => 255)
        t.column(:text, :text)
        t.column(:zone, :text)
        t.column(:url, :string, :limit => 255)
        t.column(:controller, :string, :limit => 255)
        t.column(:action, :string, :limit => 255)
        t.column(:created_at, :datetime)
        t.column(:user_id, :integer)
        t.column(:ip, :string, :limit => 255)
        t.column(:ua, :string, :limit => 255)
        t.column(:browser, :text)
        t.column(:lft, :integer)
        t.column(:parent_id, :integer)
        t.column(:rgt, :integer)
      end
      puts("New Table dev_feedbacks Added (16 Fields)")
    else # table detected
      field_names = DevFeedback.columns.map(&:name)

      if !field_names.include?('ticket_status')
        db_conn.add_column('dev_feedbacks', :ticket_status, :integer)
        puts("ticket_status (integer) added to dev_feedbacks")
      end

      if !field_names.include?('title')
        db_conn.add_column('dev_feedbacks', :title, :string, :limit => 255)
        puts("title (string) added to dev_feedbacks")
      end

      if !field_names.include?('text')
        db_conn.add_column('dev_feedbacks', :text, :text)
        puts("text (text) added to dev_feedbacks")
      end

      if !field_names.include?('zone')
        db_conn.add_column('dev_feedbacks', :zone, :text)
        puts("zone (text) added to dev_feedbacks")
      end

      if !field_names.include?('url')
        db_conn.add_column('dev_feedbacks', :url, :string, :limit => 255)
        puts("url (string) added to dev_feedbacks")
      end

      if !field_names.include?('controller')
        db_conn.add_column('dev_feedbacks', :controller, :string, :limit => 255)
        puts("controller (string) added to dev_feedbacks")
      end

      if !field_names.include?('action')
        db_conn.add_column('dev_feedbacks', :action, :string, :limit => 255)
        puts("action (string) added to dev_feedbacks")
      end

      if !field_names.include?('created_at')
        db_conn.add_column('dev_feedbacks', :created_at, :datetime)
        puts("created_at (datetime) added to dev_feedbacks")
      end

      if !field_names.include?('user_id')
        db_conn.add_column('dev_feedbacks', :user_id, :integer)
        puts("user_id (integer) added to dev_feedbacks")
      end

      if !field_names.include?('ip')
        db_conn.add_column('dev_feedbacks', :ip, :string, :limit => 255)
        puts("ip (string) added to dev_feedbacks")
      end

      if !field_names.include?('ua')
        db_conn.add_column('dev_feedbacks', :ua, :string, :limit => 255)
        puts("ua (string) added to dev_feedbacks")
      end

      if !field_names.include?('browser')
        db_conn.add_column('dev_feedbacks', :browser, :text)
        puts("browser (text) added to dev_feedbacks")
      end

      if !field_names.include?('lft')
        db_conn.add_column('dev_feedbacks', :lft, :integer)
        puts("lft (integer) added to dev_feedbacks")
      end

      if !field_names.include?('parent_id')
        db_conn.add_column('dev_feedbacks', :parent_id, :integer)
        puts("parent_id (integer) added to dev_feedbacks")
      end

      if !field_names.include?('rgt')
        db_conn.add_column('dev_feedbacks', :rgt, :integer)
        puts("rgt (integer) added to dev_feedbacks")
      end


# Add Uniq constraints

    end


# Maveoc: Translations, table: translations
    if !db_conn.tables.include?('translations')
      db_conn.create_table :translations do |t|
      end
      puts("New Table translations Added (1 Fields)")
    else # table detected
      field_names = Translation.columns.map(&:name)


# Add Uniq constraints

    end



# Indexes
  if add_indexes

    begin
      db_conn.add_index(:profile_accesses, :profile_id)
      puts("Index for profile_id on Table profile_accesses Added")
    rescue => e
    end

    begin
      db_conn.add_index(:profile_accesses, :access_id)
      puts("Index for access_id on Table profile_accesses Added")
    rescue => e
    end

    begin
      db_conn.add_index(:user_accesses, :access_id)
      puts("Index for access_id on Table user_accesses Added")
    rescue => e
    end

    begin
      db_conn.add_index(:user_accesses, :user_id)
      puts("Index for user_id on Table user_accesses Added")
    rescue => e
    end

    begin
      db_conn.add_index(:profiles, :home_page_id)
      puts("Index for home_page_id on Table profiles Added")
    rescue => e
    end

    begin
      db_conn.add_index(:dev_feedbacks, :user_id)
      puts("Index for user_id on Table dev_feedbacks Added")
    rescue => e
    end

    begin
      db_conn.add_index(:file_imports, :user_id)
      puts("Index for user_id on Table file_imports Added")
    rescue => e
    end

    begin
      db_conn.add_index(:file_imports, :file_import_id)
      puts("Index for file_import_id on Table file_imports Added")
    rescue => e
    end

    begin
      db_conn.add_index(:customers, :user_id)
      puts("Index for user_id on Table customers Added")
    rescue => e
    end

  end

# Foreign Keys
  if add_constraints

    begin
      db_conn.add_foreign_key(:profile_accesses, :profiles, :column => 'profile_id')
      puts("Foreign Keys profile_id on Table profile_accesses Added")
    rescue => e
    end

    begin
      db_conn.add_foreign_key(:profile_accesses, :accesses, :column => 'access_id', :dependent => :delete)
      puts("Foreign Keys access_id on Table profile_accesses Added")
    rescue => e
    end

    begin
      db_conn.add_foreign_key(:user_accesses, :accesses, :column => 'access_id', :dependent => :delete)
      puts("Foreign Keys access_id on Table user_accesses Added")
    rescue => e
    end

    begin
      db_conn.add_foreign_key(:user_accesses, :users, :column => 'user_id', :dependent => :delete)
      puts("Foreign Keys user_id on Table user_accesses Added")
    rescue => e
    end

    begin
      db_conn.add_foreign_key(:profiles, :accesses, :column => 'home_page_id')
      puts("Foreign Keys home_page_id on Table profiles Added")
    rescue => e
    end

    begin
      db_conn.add_foreign_key(:dev_feedbacks, :users, :column => 'user_id')
      puts("Foreign Keys user_id on Table dev_feedbacks Added")
    rescue => e
    end

    begin
      db_conn.add_foreign_key(:file_imports, :users, :column => 'user_id')
      puts("Foreign Keys user_id on Table file_imports Added")
    rescue => e
    end

    begin
      db_conn.add_foreign_key(:file_imports, :file_imports, :column => 'file_import_id')
      puts("Foreign Keys file_import_id on Table file_imports Added")
    rescue => e
    end

    begin
      db_conn.add_foreign_key(:customers, :users, :column => 'user_id')
      puts("Foreign Keys user_id on Table customers Added")
    rescue => e
    end

  end

# Join Tables

  if !db_conn.tables.include?('profiles_users')
    db_conn.create_table(:profiles_users, :id => false) do |t|
      t.column(:user_id, :integer)
      t.column(:profile_id, :integer)
    end
    db_conn.add_index(:profiles_users, ['user_id','profile_id']) rescue ActiveRecord::StatementInvalid
    puts("Join Table profiles_users Added")
  end
  if add_constraints
    begin
      db_conn.add_foreign_key(:profiles_users, :users, :column => 'user_id', :dependent => :delete)
      db_conn.add_foreign_key(:profiles_users, :profiles, :column => 'profile_id', :dependent => :delete)
      puts("Foreign Keys on Join Table profiles_users Added")
    rescue => e
    end
  end

  end
  
  
  desc "Add Accesses in the DB"
  task :add_accesses => :environment do

  a = Access.all(:conditions => {:table_sid => 'root_maveocs'}).select{|a| a.action_sid.blank? && a.field_sid.blank?}.first
  if a
    if a.app_sid != 'System'
      a.app_sid = 'System'
      a.save
    end
  else
    Access.create(:app_sid => 'System', :table_sid => 'root_maveocs')
  end
  # Fields
  
  # Actions
  
  
  a = Access.all(:conditions => {:table_sid => 'customers'}).select{|a| a.action_sid.blank? && a.field_sid.blank?}.first
  if a
    if a.app_sid != 'None'
      a.app_sid = 'None'
      a.save
    end
  else
    Access.create(:app_sid => 'None', :table_sid => 'customers')
  end
  # Fields
  
  Access.create(:app_sid => 'None', :table_sid => 'customers', :field_sid => 'first_name')
  Access.create(:app_sid => 'None', :table_sid => 'customers', :field_sid => 'last_name')
  Access.create(:app_sid => 'None', :table_sid => 'customers', :field_sid => 'photo')
  Access.create(:app_sid => 'None', :table_sid => 'customers', :field_sid => 'user')
  Access.create(:app_sid => 'None', :table_sid => 'customers', :field_sid => 'new_date')
  Access.create(:app_sid => 'None', :table_sid => 'customers', :field_sid => 'new_string')
  # Actions
  
  Access.create(:app_sid => 'None', :table_sid => 'customers', :action_sid => 'index')
  Access.create(:app_sid => 'None', :table_sid => 'customers', :action_sid => 'list')
  Access.create(:app_sid => 'None', :table_sid => 'customers', :action_sid => 'new')
  Access.create(:app_sid => 'None', :table_sid => 'customers', :action_sid => 'create')
  Access.create(:app_sid => 'None', :table_sid => 'customers', :action_sid => 'show')
  Access.create(:app_sid => 'None', :table_sid => 'customers', :action_sid => 'edit')
  Access.create(:app_sid => 'None', :table_sid => 'customers', :action_sid => 'update')
  Access.create(:app_sid => 'None', :table_sid => 'customers', :action_sid => 'destroy')
  Access.create(:app_sid => 'None', :table_sid => 'customers', :action_sid => 'search')
  Access.create(:app_sid => 'None', :table_sid => 'customers', :action_sid => 'download')
  Access.create(:app_sid => 'None', :table_sid => 'customers', :action_sid => 'feed')
  Access.create(:app_sid => 'None', :table_sid => 'customers', :action_sid => 'help')
  Access.create(:app_sid => 'None', :table_sid => 'customers', :action_sid => 'adv_search')
  Access.create(:app_sid => 'None', :table_sid => 'customers', :action_sid => 'linker')
  Access.create(:app_sid => 'None', :table_sid => 'customers', :action_sid => 'get_file_thumb')
  Access.create(:app_sid => 'None', :table_sid => 'customers', :action_sid => 'get_file_size')
  Access.create(:app_sid => 'None', :table_sid => 'customers', :action_sid => 'get_file')
  
  a = Access.all(:conditions => {:table_sid => 'system_settings'}).select{|a| a.action_sid.blank? && a.field_sid.blank?}.first
  if a
    if a.app_sid != 'System'
      a.app_sid = 'System'
      a.save
    end
  else
    Access.create(:app_sid => 'System', :table_sid => 'system_settings')
  end
  # Fields
  
  Access.create(:app_sid => 'System', :table_sid => 'system_settings', :field_sid => 'name')
  Access.create(:app_sid => 'System', :table_sid => 'system_settings', :field_sid => 'value')
  # Actions
  
  Access.create(:app_sid => 'System', :table_sid => 'system_settings', :action_sid => 'list')
  Access.create(:app_sid => 'System', :table_sid => 'system_settings', :action_sid => 'new')
  Access.create(:app_sid => 'System', :table_sid => 'system_settings', :action_sid => 'create')
  Access.create(:app_sid => 'System', :table_sid => 'system_settings', :action_sid => 'show')
  Access.create(:app_sid => 'System', :table_sid => 'system_settings', :action_sid => 'edit')
  Access.create(:app_sid => 'System', :table_sid => 'system_settings', :action_sid => 'update')
  Access.create(:app_sid => 'System', :table_sid => 'system_settings', :action_sid => 'destroy')
  Access.create(:app_sid => 'System', :table_sid => 'system_settings', :action_sid => 'search')
  Access.create(:app_sid => 'System', :table_sid => 'system_settings', :action_sid => 'download')
  Access.create(:app_sid => 'System', :table_sid => 'system_settings', :action_sid => 'feed')
  Access.create(:app_sid => 'System', :table_sid => 'system_settings', :action_sid => 'help')
  Access.create(:app_sid => 'System', :table_sid => 'system_settings', :action_sid => 'adv_search')
  Access.create(:app_sid => 'System', :table_sid => 'system_settings', :action_sid => 'index')
  Access.create(:app_sid => 'System', :table_sid => 'system_settings', :action_sid => 'dev_doc')
  Access.create(:app_sid => 'System', :table_sid => 'system_settings', :action_sid => 'gen_doc')
  Access.create(:app_sid => 'System', :table_sid => 'system_settings', :action_sid => 'routes')
  Access.create(:app_sid => 'System', :table_sid => 'system_settings', :action_sid => 'page_icons')
  Access.create(:app_sid => 'System', :table_sid => 'system_settings', :action_sid => 'file_icons')
  Access.create(:app_sid => 'System', :table_sid => 'system_settings', :action_sid => 'monitoring')
  Access.create(:app_sid => 'System', :table_sid => 'system_settings', :action_sid => 'requests_times')
  Access.create(:app_sid => 'System', :table_sid => 'system_settings', :action_sid => 'list_logs')
  Access.create(:app_sid => 'System', :table_sid => 'system_settings', :action_sid => 'clear_logs')
  Access.create(:app_sid => 'System', :table_sid => 'system_settings', :action_sid => 'reload')
  Access.create(:app_sid => 'System', :table_sid => 'system_settings', :action_sid => 'public_files')
  Access.create(:app_sid => 'System', :table_sid => 'system_settings', :action_sid => 'node_details')
  Access.create(:app_sid => 'System', :table_sid => 'system_settings', :action_sid => 'dependency_graph')
  Access.create(:app_sid => 'System', :table_sid => 'system_settings', :action_sid => 'upload_form')
  Access.create(:app_sid => 'System', :table_sid => 'system_settings', :action_sid => 'console')
  Access.create(:app_sid => 'System', :table_sid => 'system_settings', :action_sid => 'sql_console')
  Access.create(:app_sid => 'System', :table_sid => 'system_settings', :action_sid => 'download_zip')
  Access.create(:app_sid => 'System', :table_sid => 'system_settings', :action_sid => 'irbjax')
  Access.create(:app_sid => 'System', :table_sid => 'system_settings', :action_sid => 'run_command')
  
  a = Access.all(:conditions => {:table_sid => 'accesses'}).select{|a| a.action_sid.blank? && a.field_sid.blank?}.first
  if a
    if a.app_sid != 'System'
      a.app_sid = 'System'
      a.save
    end
  else
    Access.create(:app_sid => 'System', :table_sid => 'accesses')
  end
  # Fields
  
  Access.create(:app_sid => 'System', :table_sid => 'accesses', :field_sid => 'app_sid')
  Access.create(:app_sid => 'System', :table_sid => 'accesses', :field_sid => 'set_sid')
  Access.create(:app_sid => 'System', :table_sid => 'accesses', :field_sid => 'table_sid')
  Access.create(:app_sid => 'System', :table_sid => 'accesses', :field_sid => 'field_sid')
  Access.create(:app_sid => 'System', :table_sid => 'accesses', :field_sid => 'action_sid')
  Access.create(:app_sid => 'System', :table_sid => 'accesses', :field_sid => 'type_sid')
  Access.create(:app_sid => 'System', :table_sid => 'accesses', :field_sid => 'home_page_profiles')
  Access.create(:app_sid => 'System', :table_sid => 'accesses', :field_sid => 'user_accesses')
  Access.create(:app_sid => 'System', :table_sid => 'accesses', :field_sid => 'profile_accesses')
  # Actions
  
  Access.create(:app_sid => 'System', :table_sid => 'accesses', :action_sid => 'index')
  Access.create(:app_sid => 'System', :table_sid => 'accesses', :action_sid => 'list')
  Access.create(:app_sid => 'System', :table_sid => 'accesses', :action_sid => 'download')
  Access.create(:app_sid => 'System', :table_sid => 'accesses', :action_sid => 'set_permission')
  Access.create(:app_sid => 'System', :table_sid => 'accesses', :action_sid => 'reporting')
  Access.create(:app_sid => 'System', :table_sid => 'accesses', :action_sid => 'reporting_data')
  Access.create(:app_sid => 'System', :table_sid => 'accesses', :action_sid => 'permissions')
  Access.create(:app_sid => 'System', :table_sid => 'accesses', :action_sid => 'set_access')
  Access.create(:app_sid => 'System', :table_sid => 'accesses', :action_sid => 'linker')
  Access.create(:app_sid => 'System', :table_sid => 'accesses', :action_sid => 'report_chooser')
  Access.create(:app_sid => 'System', :table_sid => 'accesses', :action_sid => 'report_generate')
  Access.create(:app_sid => 'System', :table_sid => 'accesses', :action_sid => 'report_load_labels')
  
  a = Access.all(:conditions => {:table_sid => 'profile_accesses'}).select{|a| a.action_sid.blank? && a.field_sid.blank?}.first
  if a
    if a.app_sid != 'System'
      a.app_sid = 'System'
      a.save
    end
  else
    Access.create(:app_sid => 'System', :table_sid => 'profile_accesses')
  end
  # Fields
  
  Access.create(:app_sid => 'System', :table_sid => 'profile_accesses', :field_sid => 'profile')
  Access.create(:app_sid => 'System', :table_sid => 'profile_accesses', :field_sid => 'access')
  Access.create(:app_sid => 'System', :table_sid => 'profile_accesses', :field_sid => 'read')
  Access.create(:app_sid => 'System', :table_sid => 'profile_accesses', :field_sid => 'write')
  # Actions
  
  Access.create(:app_sid => 'System', :table_sid => 'profile_accesses', :action_sid => 'linker')
  
  a = Access.all(:conditions => {:table_sid => 'user_accesses'}).select{|a| a.action_sid.blank? && a.field_sid.blank?}.first
  if a
    if a.app_sid != 'System'
      a.app_sid = 'System'
      a.save
    end
  else
    Access.create(:app_sid => 'System', :table_sid => 'user_accesses')
  end
  # Fields
  
  Access.create(:app_sid => 'System', :table_sid => 'user_accesses', :field_sid => 'user')
  Access.create(:app_sid => 'System', :table_sid => 'user_accesses', :field_sid => 'access')
  Access.create(:app_sid => 'System', :table_sid => 'user_accesses', :field_sid => 'read')
  Access.create(:app_sid => 'System', :table_sid => 'user_accesses', :field_sid => 'write')
  # Actions
  
  Access.create(:app_sid => 'System', :table_sid => 'user_accesses', :action_sid => 'linker')
  
  a = Access.all(:conditions => {:table_sid => 'profiles'}).select{|a| a.action_sid.blank? && a.field_sid.blank?}.first
  if a
    if a.app_sid != 'System'
      a.app_sid = 'System'
      a.save
    end
  else
    Access.create(:app_sid => 'System', :table_sid => 'profiles')
  end
  # Fields
  
  Access.create(:app_sid => 'System', :table_sid => 'profiles', :field_sid => 'name')
  Access.create(:app_sid => 'System', :table_sid => 'profiles', :field_sid => 'users')
  Access.create(:app_sid => 'System', :table_sid => 'profiles', :field_sid => 'home_page')
  Access.create(:app_sid => 'System', :table_sid => 'profiles', :field_sid => 'profile_accesses')
  # Actions
  
  Access.create(:app_sid => 'System', :table_sid => 'profiles', :action_sid => 'index')
  Access.create(:app_sid => 'System', :table_sid => 'profiles', :action_sid => 'list')
  Access.create(:app_sid => 'System', :table_sid => 'profiles', :action_sid => 'new')
  Access.create(:app_sid => 'System', :table_sid => 'profiles', :action_sid => 'create')
  Access.create(:app_sid => 'System', :table_sid => 'profiles', :action_sid => 'show')
  Access.create(:app_sid => 'System', :table_sid => 'profiles', :action_sid => 'edit')
  Access.create(:app_sid => 'System', :table_sid => 'profiles', :action_sid => 'update')
  Access.create(:app_sid => 'System', :table_sid => 'profiles', :action_sid => 'destroy')
  Access.create(:app_sid => 'System', :table_sid => 'profiles', :action_sid => 'search')
  Access.create(:app_sid => 'System', :table_sid => 'profiles', :action_sid => 'access_graph')
  Access.create(:app_sid => 'System', :table_sid => 'profiles', :action_sid => 'field_access_graph')
  Access.create(:app_sid => 'System', :table_sid => 'profiles', :action_sid => 'linker')
  
  a = Access.all(:conditions => {:table_sid => 'users'}).select{|a| a.action_sid.blank? && a.field_sid.blank?}.first
  if a
    if a.app_sid != 'System'
      a.app_sid = 'System'
      a.save
    end
  else
    Access.create(:app_sid => 'System', :table_sid => 'users')
  end
  # Fields
  
  Access.create(:app_sid => 'System', :table_sid => 'users', :field_sid => 'login')
  Access.create(:app_sid => 'System', :table_sid => 'users', :field_sid => 'first_name')
  Access.create(:app_sid => 'System', :table_sid => 'users', :field_sid => 'last_name')
  Access.create(:app_sid => 'System', :table_sid => 'users', :field_sid => 'email')
  Access.create(:app_sid => 'System', :table_sid => 'users', :field_sid => 'customers')
  Access.create(:app_sid => 'System', :table_sid => 'users', :field_sid => 'telephone')
  Access.create(:app_sid => 'System', :table_sid => 'users', :field_sid => 'language')
  Access.create(:app_sid => 'System', :table_sid => 'users', :field_sid => 'active')
  Access.create(:app_sid => 'System', :table_sid => 'users', :field_sid => 'hashed_password')
  Access.create(:app_sid => 'System', :table_sid => 'users', :field_sid => 'salt')
  Access.create(:app_sid => 'System', :table_sid => 'users', :field_sid => 'last_login')
  Access.create(:app_sid => 'System', :table_sid => 'users', :field_sid => 'last_session_id')
  Access.create(:app_sid => 'System', :table_sid => 'users', :field_sid => 'user_accesses')
  Access.create(:app_sid => 'System', :table_sid => 'users', :field_sid => 'profiles')
  Access.create(:app_sid => 'System', :table_sid => 'users', :field_sid => 'dev_feedbacks')
  Access.create(:app_sid => 'System', :table_sid => 'users', :field_sid => 'file_imports')
  # Actions
  
  Access.create(:app_sid => 'System', :table_sid => 'users', :action_sid => 'index')
  Access.create(:app_sid => 'System', :table_sid => 'users', :action_sid => 'list')
  Access.create(:app_sid => 'System', :table_sid => 'users', :action_sid => 'new')
  Access.create(:app_sid => 'System', :table_sid => 'users', :action_sid => 'create')
  Access.create(:app_sid => 'System', :table_sid => 'users', :action_sid => 'show')
  Access.create(:app_sid => 'System', :table_sid => 'users', :action_sid => 'edit')
  Access.create(:app_sid => 'System', :table_sid => 'users', :action_sid => 'update')
  Access.create(:app_sid => 'System', :table_sid => 'users', :action_sid => 'destroy')
  Access.create(:app_sid => 'System', :table_sid => 'users', :action_sid => 'search')
  Access.create(:app_sid => 'System', :table_sid => 'users', :action_sid => 'download')
  Access.create(:app_sid => 'System', :table_sid => 'users', :action_sid => 'feed')
  Access.create(:app_sid => 'System', :table_sid => 'users', :action_sid => 'help')
  Access.create(:app_sid => 'System', :table_sid => 'users', :action_sid => 'login')
  Access.create(:app_sid => 'System', :table_sid => 'users', :action_sid => 'logout')
  Access.create(:app_sid => 'System', :table_sid => 'users', :action_sid => 'home')
  Access.create(:app_sid => 'System', :table_sid => 'users', :action_sid => 'access_graph')
  Access.create(:app_sid => 'System', :table_sid => 'users', :action_sid => 'field_access_graph')
  Access.create(:app_sid => 'System', :table_sid => 'users', :action_sid => 'change_password')
  Access.create(:app_sid => 'System', :table_sid => 'users', :action_sid => 'linker')
  Access.create(:app_sid => 'System', :table_sid => 'users', :action_sid => 'report_chooser')
  Access.create(:app_sid => 'System', :table_sid => 'users', :action_sid => 'report_generate')
  Access.create(:app_sid => 'System', :table_sid => 'users', :action_sid => 'report_load_labels')
  Access.create(:app_sid => 'System', :table_sid => 'users', :action_sid => 'reporting')
  Access.create(:app_sid => 'System', :table_sid => 'users', :action_sid => 'reporting_data')
  
  a = Access.all(:conditions => {:table_sid => 'app_locales'}).select{|a| a.action_sid.blank? && a.field_sid.blank?}.first
  if a
    if a.app_sid != 'System'
      a.app_sid = 'System'
      a.save
    end
  else
    Access.create(:app_sid => 'System', :table_sid => 'app_locales')
  end
  # Fields
  
  Access.create(:app_sid => 'System', :table_sid => 'app_locales', :field_sid => 'locale_code')
  Access.create(:app_sid => 'System', :table_sid => 'app_locales', :field_sid => 'po')
  Access.create(:app_sid => 'System', :table_sid => 'app_locales', :field_sid => 'updated_at')
  # Actions
  
  Access.create(:app_sid => 'System', :table_sid => 'app_locales', :action_sid => 'list')
  Access.create(:app_sid => 'System', :table_sid => 'app_locales', :action_sid => 'new')
  Access.create(:app_sid => 'System', :table_sid => 'app_locales', :action_sid => 'create')
  Access.create(:app_sid => 'System', :table_sid => 'app_locales', :action_sid => 'show')
  Access.create(:app_sid => 'System', :table_sid => 'app_locales', :action_sid => 'update')
  Access.create(:app_sid => 'System', :table_sid => 'app_locales', :action_sid => 'destroy')
  Access.create(:app_sid => 'System', :table_sid => 'app_locales', :action_sid => 'feed')
  Access.create(:app_sid => 'System', :table_sid => 'app_locales', :action_sid => 'help')
  Access.create(:app_sid => 'System', :table_sid => 'app_locales', :action_sid => 'update_po')
  Access.create(:app_sid => 'System', :table_sid => 'app_locales', :action_sid => 'po_files')
  Access.create(:app_sid => 'System', :table_sid => 'app_locales', :action_sid => 'get_po_file')
  Access.create(:app_sid => 'System', :table_sid => 'app_locales', :action_sid => 'translate_deprecated')
  Access.create(:app_sid => 'System', :table_sid => 'app_locales', :action_sid => 'index')
  Access.create(:app_sid => 'System', :table_sid => 'app_locales', :action_sid => 'edit')
  Access.create(:app_sid => 'System', :table_sid => 'app_locales', :action_sid => 'make_mo')
  Access.create(:app_sid => 'System', :table_sid => 'app_locales', :action_sid => 'auto_translate_all')
  Access.create(:app_sid => 'System', :table_sid => 'app_locales', :action_sid => 'submit')
  Access.create(:app_sid => 'System', :table_sid => 'app_locales', :action_sid => 'auto_translate')
  Access.create(:app_sid => 'System', :table_sid => 'app_locales', :action_sid => 'get_file_thumb')
  Access.create(:app_sid => 'System', :table_sid => 'app_locales', :action_sid => 'get_file_size')
  Access.create(:app_sid => 'System', :table_sid => 'app_locales', :action_sid => 'get_file')
  
  a = Access.all(:conditions => {:table_sid => 'bg_workers'}).select{|a| a.action_sid.blank? && a.field_sid.blank?}.first
  if a
    if a.app_sid != 'System'
      a.app_sid = 'System'
      a.save
    end
  else
    Access.create(:app_sid => 'System', :table_sid => 'bg_workers')
  end
  # Fields
  
  Access.create(:app_sid => 'System', :table_sid => 'bg_workers', :field_sid => 'every')
  Access.create(:app_sid => 'System', :table_sid => 'bg_workers', :field_sid => 'from')
  Access.create(:app_sid => 'System', :table_sid => 'bg_workers', :field_sid => 'cron')
  Access.create(:app_sid => 'System', :table_sid => 'bg_workers', :field_sid => 'triggered_by')
  Access.create(:app_sid => 'System', :table_sid => 'bg_workers', :field_sid => 'no_duplicate')
  Access.create(:app_sid => 'System', :table_sid => 'bg_workers', :field_sid => 'name')
  Access.create(:app_sid => 'System', :table_sid => 'bg_workers', :field_sid => 'priority')
  Access.create(:app_sid => 'System', :table_sid => 'bg_workers', :field_sid => 'planned_at')
  Access.create(:app_sid => 'System', :table_sid => 'bg_workers', :field_sid => 'created_at')
  Access.create(:app_sid => 'System', :table_sid => 'bg_workers', :field_sid => 'started_at')
  Access.create(:app_sid => 'System', :table_sid => 'bg_workers', :field_sid => 'locked_at')
  Access.create(:app_sid => 'System', :table_sid => 'bg_workers', :field_sid => 'locked_by')
  Access.create(:app_sid => 'System', :table_sid => 'bg_workers', :field_sid => 'completed_at')
  Access.create(:app_sid => 'System', :table_sid => 'bg_workers', :field_sid => 'last_return_code')
  Access.create(:app_sid => 'System', :table_sid => 'bg_workers', :field_sid => 'attempts')
  Access.create(:app_sid => 'System', :table_sid => 'bg_workers', :field_sid => 'failed_at')
  Access.create(:app_sid => 'System', :table_sid => 'bg_workers', :field_sid => 'logs')
  # Actions
  
  Access.create(:app_sid => 'System', :table_sid => 'bg_workers', :action_sid => 'index')
  Access.create(:app_sid => 'System', :table_sid => 'bg_workers', :action_sid => 'new')
  Access.create(:app_sid => 'System', :table_sid => 'bg_workers', :action_sid => 'create')
  Access.create(:app_sid => 'System', :table_sid => 'bg_workers', :action_sid => 'show')
  Access.create(:app_sid => 'System', :table_sid => 'bg_workers', :action_sid => 'edit')
  Access.create(:app_sid => 'System', :table_sid => 'bg_workers', :action_sid => 'update')
  Access.create(:app_sid => 'System', :table_sid => 'bg_workers', :action_sid => 'destroy')
  Access.create(:app_sid => 'System', :table_sid => 'bg_workers', :action_sid => 'search')
  Access.create(:app_sid => 'System', :table_sid => 'bg_workers', :action_sid => 'help')
  Access.create(:app_sid => 'System', :table_sid => 'bg_workers', :action_sid => 'run_job_deprecated')
  Access.create(:app_sid => 'System', :table_sid => 'bg_workers', :action_sid => 'clear_locks')
  Access.create(:app_sid => 'System', :table_sid => 'bg_workers', :action_sid => 'update_task')
  Access.create(:app_sid => 'System', :table_sid => 'bg_workers', :action_sid => 'edit_task')
  Access.create(:app_sid => 'System', :table_sid => 'bg_workers', :action_sid => 'tasks')
  Access.create(:app_sid => 'System', :table_sid => 'bg_workers', :action_sid => 'destroy_task')
  Access.create(:app_sid => 'System', :table_sid => 'bg_workers', :action_sid => 'add_task')
  Access.create(:app_sid => 'System', :table_sid => 'bg_workers', :action_sid => 'new_task')
  Access.create(:app_sid => 'System', :table_sid => 'bg_workers', :action_sid => 'list')
  Access.create(:app_sid => 'System', :table_sid => 'bg_workers', :action_sid => 'start_worker')
  Access.create(:app_sid => 'System', :table_sid => 'bg_workers', :action_sid => 'processes')
  Access.create(:app_sid => 'System', :table_sid => 'bg_workers', :action_sid => 'kill_process')
  Access.create(:app_sid => 'System', :table_sid => 'bg_workers', :action_sid => 'ptest')
  Access.create(:app_sid => 'System', :table_sid => 'bg_workers', :action_sid => 'clear_queue')
  Access.create(:app_sid => 'System', :table_sid => 'bg_workers', :action_sid => 'running')
  Access.create(:app_sid => 'System', :table_sid => 'bg_workers', :action_sid => 'clear_log')
  Access.create(:app_sid => 'System', :table_sid => 'bg_workers', :action_sid => 'run_task')
  Access.create(:app_sid => 'System', :table_sid => 'bg_workers', :action_sid => 'kill_task')
  Access.create(:app_sid => 'System', :table_sid => 'bg_workers', :action_sid => 'report_chooser')
  Access.create(:app_sid => 'System', :table_sid => 'bg_workers', :action_sid => 'report_generate')
  Access.create(:app_sid => 'System', :table_sid => 'bg_workers', :action_sid => 'report_load_labels')
  Access.create(:app_sid => 'System', :table_sid => 'bg_workers', :action_sid => 'reporting')
  Access.create(:app_sid => 'System', :table_sid => 'bg_workers', :action_sid => 'reporting_data')
  
  a = Access.all(:conditions => {:table_sid => 'smart_queries'}).select{|a| a.action_sid.blank? && a.field_sid.blank?}.first
  if a
    if a.app_sid != 'System'
      a.app_sid = 'System'
      a.save
    end
  else
    Access.create(:app_sid => 'System', :table_sid => 'smart_queries')
  end
  # Fields
  
  Access.create(:app_sid => 'System', :table_sid => 'smart_queries', :field_sid => 'name')
  Access.create(:app_sid => 'System', :table_sid => 'smart_queries', :field_sid => 'table_sid')
  Access.create(:app_sid => 'System', :table_sid => 'smart_queries', :field_sid => 'joining_criteria')
  Access.create(:app_sid => 'System', :table_sid => 'smart_queries', :field_sid => 'criteria')
  # Actions
  
  Access.create(:app_sid => 'System', :table_sid => 'smart_queries', :action_sid => 'index')
  Access.create(:app_sid => 'System', :table_sid => 'smart_queries', :action_sid => 'list')
  Access.create(:app_sid => 'System', :table_sid => 'smart_queries', :action_sid => 'create')
  Access.create(:app_sid => 'System', :table_sid => 'smart_queries', :action_sid => 'show')
  Access.create(:app_sid => 'System', :table_sid => 'smart_queries', :action_sid => 'update')
  Access.create(:app_sid => 'System', :table_sid => 'smart_queries', :action_sid => 'destroy')
  Access.create(:app_sid => 'System', :table_sid => 'smart_queries', :action_sid => 'search')
  Access.create(:app_sid => 'System', :table_sid => 'smart_queries', :action_sid => 'download')
  Access.create(:app_sid => 'System', :table_sid => 'smart_queries', :action_sid => 'feed')
  Access.create(:app_sid => 'System', :table_sid => 'smart_queries', :action_sid => 'help')
  Access.create(:app_sid => 'System', :table_sid => 'smart_queries', :action_sid => 'adv_search')
  Access.create(:app_sid => 'System', :table_sid => 'smart_queries', :action_sid => 'db_table')
  Access.create(:app_sid => 'System', :table_sid => 'smart_queries', :action_sid => 'new')
  Access.create(:app_sid => 'System', :table_sid => 'smart_queries', :action_sid => 'edit')
  Access.create(:app_sid => 'System', :table_sid => 'smart_queries', :action_sid => 'change_table')
  Access.create(:app_sid => 'System', :table_sid => 'smart_queries', :action_sid => 'test_query')
  Access.create(:app_sid => 'System', :table_sid => 'smart_queries', :action_sid => 'global_search')
  
  a = Access.all(:conditions => {:table_sid => 'saved_reports'}).select{|a| a.action_sid.blank? && a.field_sid.blank?}.first
  if a
    if a.app_sid != 'System'
      a.app_sid = 'System'
      a.save
    end
  else
    Access.create(:app_sid => 'System', :table_sid => 'saved_reports')
  end
  # Fields
  
  Access.create(:app_sid => 'System', :table_sid => 'saved_reports', :field_sid => 'name')
  Access.create(:app_sid => 'System', :table_sid => 'saved_reports', :field_sid => 'created_at')
  Access.create(:app_sid => 'System', :table_sid => 'saved_reports', :field_sid => 'url')
  Access.create(:app_sid => 'System', :table_sid => 'saved_reports', :field_sid => 'data')
  # Actions
  
  Access.create(:app_sid => 'System', :table_sid => 'saved_reports', :action_sid => 'index')
  Access.create(:app_sid => 'System', :table_sid => 'saved_reports', :action_sid => 'list')
  Access.create(:app_sid => 'System', :table_sid => 'saved_reports', :action_sid => 'new')
  Access.create(:app_sid => 'System', :table_sid => 'saved_reports', :action_sid => 'create')
  Access.create(:app_sid => 'System', :table_sid => 'saved_reports', :action_sid => 'show')
  Access.create(:app_sid => 'System', :table_sid => 'saved_reports', :action_sid => 'edit')
  Access.create(:app_sid => 'System', :table_sid => 'saved_reports', :action_sid => 'update')
  Access.create(:app_sid => 'System', :table_sid => 'saved_reports', :action_sid => 'destroy')
  Access.create(:app_sid => 'System', :table_sid => 'saved_reports', :action_sid => 'search')
  Access.create(:app_sid => 'System', :table_sid => 'saved_reports', :action_sid => 'download')
  Access.create(:app_sid => 'System', :table_sid => 'saved_reports', :action_sid => 'feed')
  Access.create(:app_sid => 'System', :table_sid => 'saved_reports', :action_sid => 'help')
  Access.create(:app_sid => 'System', :table_sid => 'saved_reports', :action_sid => 'adv_search')
  Access.create(:app_sid => 'System', :table_sid => 'saved_reports', :action_sid => 'ajax_create')
  Access.create(:app_sid => 'System', :table_sid => 'saved_reports', :action_sid => 'ajax_update')
  Access.create(:app_sid => 'System', :table_sid => 'saved_reports', :action_sid => 'add_report')
  
  a = Access.all(:conditions => {:table_sid => 'uncatched_exceptions'}).select{|a| a.action_sid.blank? && a.field_sid.blank?}.first
  if a
    if a.app_sid != 'System'
      a.app_sid = 'System'
      a.save
    end
  else
    Access.create(:app_sid => 'System', :table_sid => 'uncatched_exceptions')
  end
  # Fields
  
  Access.create(:app_sid => 'System', :table_sid => 'uncatched_exceptions', :field_sid => 'exception_class')
  Access.create(:app_sid => 'System', :table_sid => 'uncatched_exceptions', :field_sid => 'controller_name')
  Access.create(:app_sid => 'System', :table_sid => 'uncatched_exceptions', :field_sid => 'action_name')
  Access.create(:app_sid => 'System', :table_sid => 'uncatched_exceptions', :field_sid => 'message')
  Access.create(:app_sid => 'System', :table_sid => 'uncatched_exceptions', :field_sid => 'backtrace')
  Access.create(:app_sid => 'System', :table_sid => 'uncatched_exceptions', :field_sid => 'environment')
  Access.create(:app_sid => 'System', :table_sid => 'uncatched_exceptions', :field_sid => 'request')
  Access.create(:app_sid => 'System', :table_sid => 'uncatched_exceptions', :field_sid => 'created_at')
  # Actions
  
  Access.create(:app_sid => 'System', :table_sid => 'uncatched_exceptions', :action_sid => 'index')
  Access.create(:app_sid => 'System', :table_sid => 'uncatched_exceptions', :action_sid => 'list')
  Access.create(:app_sid => 'System', :table_sid => 'uncatched_exceptions', :action_sid => 'show')
  Access.create(:app_sid => 'System', :table_sid => 'uncatched_exceptions', :action_sid => 'destroy')
  Access.create(:app_sid => 'System', :table_sid => 'uncatched_exceptions', :action_sid => 'search')
  Access.create(:app_sid => 'System', :table_sid => 'uncatched_exceptions', :action_sid => 'download')
  Access.create(:app_sid => 'System', :table_sid => 'uncatched_exceptions', :action_sid => 'feed')
  Access.create(:app_sid => 'System', :table_sid => 'uncatched_exceptions', :action_sid => 'help')
  Access.create(:app_sid => 'System', :table_sid => 'uncatched_exceptions', :action_sid => 'adv_search')
  Access.create(:app_sid => 'System', :table_sid => 'uncatched_exceptions', :action_sid => 'create_error')
  
  a = Access.all(:conditions => {:table_sid => 'file_imports'}).select{|a| a.action_sid.blank? && a.field_sid.blank?}.first
  if a
    if a.app_sid != 'System'
      a.app_sid = 'System'
      a.save
    end
  else
    Access.create(:app_sid => 'System', :table_sid => 'file_imports')
  end
  # Fields
  
  Access.create(:app_sid => 'System', :table_sid => 'file_imports', :field_sid => 'user')
  Access.create(:app_sid => 'System', :table_sid => 'file_imports', :field_sid => 'file')
  Access.create(:app_sid => 'System', :table_sid => 'file_imports', :field_sid => 'file_import')
  Access.create(:app_sid => 'System', :table_sid => 'file_imports', :field_sid => 're_imports')
  Access.create(:app_sid => 'System', :table_sid => 'file_imports', :field_sid => 'started_at')
  Access.create(:app_sid => 'System', :table_sid => 'file_imports', :field_sid => 'completed_at')
  Access.create(:app_sid => 'System', :table_sid => 'file_imports', :field_sid => 'read_lines')
  Access.create(:app_sid => 'System', :table_sid => 'file_imports', :field_sid => 'wrote_records')
  Access.create(:app_sid => 'System', :table_sid => 'file_imports', :field_sid => 'expected_total')
  Access.create(:app_sid => 'System', :table_sid => 'file_imports', :field_sid => 'error_count')
  Access.create(:app_sid => 'System', :table_sid => 'file_imports', :field_sid => 'log')
  # Actions
  
  Access.create(:app_sid => 'System', :table_sid => 'file_imports', :action_sid => 'index')
  Access.create(:app_sid => 'System', :table_sid => 'file_imports', :action_sid => 'new')
  Access.create(:app_sid => 'System', :table_sid => 'file_imports', :action_sid => 'create')
  Access.create(:app_sid => 'System', :table_sid => 'file_imports', :action_sid => 'show')
  Access.create(:app_sid => 'System', :table_sid => 'file_imports', :action_sid => 'edit')
  Access.create(:app_sid => 'System', :table_sid => 'file_imports', :action_sid => 'update')
  Access.create(:app_sid => 'System', :table_sid => 'file_imports', :action_sid => 'destroy')
  Access.create(:app_sid => 'System', :table_sid => 'file_imports', :action_sid => 'search')
  Access.create(:app_sid => 'System', :table_sid => 'file_imports', :action_sid => 'download')
  Access.create(:app_sid => 'System', :table_sid => 'file_imports', :action_sid => 'feed')
  Access.create(:app_sid => 'System', :table_sid => 'file_imports', :action_sid => 'help')
  Access.create(:app_sid => 'System', :table_sid => 'file_imports', :action_sid => 'adv_search')
  Access.create(:app_sid => 'System', :table_sid => 'file_imports', :action_sid => 'preview')
  Access.create(:app_sid => 'System', :table_sid => 'file_imports', :action_sid => 'load')
  Access.create(:app_sid => 'System', :table_sid => 'file_imports', :action_sid => 'list')
  Access.create(:app_sid => 'System', :table_sid => 'file_imports', :action_sid => 'source_files')
  Access.create(:app_sid => 'System', :table_sid => 'file_imports', :action_sid => 'running')
  Access.create(:app_sid => 'System', :table_sid => 'file_imports', :action_sid => 'complete')
  Access.create(:app_sid => 'System', :table_sid => 'file_imports', :action_sid => 'linker')
  Access.create(:app_sid => 'System', :table_sid => 'file_imports', :action_sid => 'get_file_thumb')
  Access.create(:app_sid => 'System', :table_sid => 'file_imports', :action_sid => 'report_chooser')
  Access.create(:app_sid => 'System', :table_sid => 'file_imports', :action_sid => 'report_generate')
  Access.create(:app_sid => 'System', :table_sid => 'file_imports', :action_sid => 'report_load_labels')
  Access.create(:app_sid => 'System', :table_sid => 'file_imports', :action_sid => 'get_file_size')
  Access.create(:app_sid => 'System', :table_sid => 'file_imports', :action_sid => 'get_file')
  Access.create(:app_sid => 'System', :table_sid => 'file_imports', :action_sid => 'reporting')
  Access.create(:app_sid => 'System', :table_sid => 'file_imports', :action_sid => 'reporting_data')
  
  a = Access.all(:conditions => {:table_sid => 'dev_feedbacks'}).select{|a| a.action_sid.blank? && a.field_sid.blank?}.first
  if a
    if a.app_sid != 'System'
      a.app_sid = 'System'
      a.save
    end
  else
    Access.create(:app_sid => 'System', :table_sid => 'dev_feedbacks')
  end
  # Fields
  
  Access.create(:app_sid => 'System', :table_sid => 'dev_feedbacks', :field_sid => 'ticket_status')
  Access.create(:app_sid => 'System', :table_sid => 'dev_feedbacks', :field_sid => 'title')
  Access.create(:app_sid => 'System', :table_sid => 'dev_feedbacks', :field_sid => 'text')
  Access.create(:app_sid => 'System', :table_sid => 'dev_feedbacks', :field_sid => 'zone')
  Access.create(:app_sid => 'System', :table_sid => 'dev_feedbacks', :field_sid => 'url')
  Access.create(:app_sid => 'System', :table_sid => 'dev_feedbacks', :field_sid => 'controller')
  Access.create(:app_sid => 'System', :table_sid => 'dev_feedbacks', :field_sid => 'action')
  Access.create(:app_sid => 'System', :table_sid => 'dev_feedbacks', :field_sid => 'created_at')
  Access.create(:app_sid => 'System', :table_sid => 'dev_feedbacks', :field_sid => 'user')
  Access.create(:app_sid => 'System', :table_sid => 'dev_feedbacks', :field_sid => 'ip')
  Access.create(:app_sid => 'System', :table_sid => 'dev_feedbacks', :field_sid => 'ua')
  Access.create(:app_sid => 'System', :table_sid => 'dev_feedbacks', :field_sid => 'browser')
  Access.create(:app_sid => 'System', :table_sid => 'dev_feedbacks', :field_sid => 'lft')
  Access.create(:app_sid => 'System', :table_sid => 'dev_feedbacks', :field_sid => 'parent_id')
  Access.create(:app_sid => 'System', :table_sid => 'dev_feedbacks', :field_sid => 'rgt')
  # Actions
  
  Access.create(:app_sid => 'System', :table_sid => 'dev_feedbacks', :action_sid => 'index')
  Access.create(:app_sid => 'System', :table_sid => 'dev_feedbacks', :action_sid => 'list')
  Access.create(:app_sid => 'System', :table_sid => 'dev_feedbacks', :action_sid => 'new')
  Access.create(:app_sid => 'System', :table_sid => 'dev_feedbacks', :action_sid => 'create')
  Access.create(:app_sid => 'System', :table_sid => 'dev_feedbacks', :action_sid => 'show')
  Access.create(:app_sid => 'System', :table_sid => 'dev_feedbacks', :action_sid => 'edit')
  Access.create(:app_sid => 'System', :table_sid => 'dev_feedbacks', :action_sid => 'update')
  Access.create(:app_sid => 'System', :table_sid => 'dev_feedbacks', :action_sid => 'destroy')
  Access.create(:app_sid => 'System', :table_sid => 'dev_feedbacks', :action_sid => 'search')
  Access.create(:app_sid => 'System', :table_sid => 'dev_feedbacks', :action_sid => 'download')
  Access.create(:app_sid => 'System', :table_sid => 'dev_feedbacks', :action_sid => 'feed')
  Access.create(:app_sid => 'System', :table_sid => 'dev_feedbacks', :action_sid => 'help')
  Access.create(:app_sid => 'System', :table_sid => 'dev_feedbacks', :action_sid => 'adv_search')
  Access.create(:app_sid => 'System', :table_sid => 'dev_feedbacks', :action_sid => 'linker')
  Access.create(:app_sid => 'System', :table_sid => 'dev_feedbacks', :action_sid => 'report_chooser')
  Access.create(:app_sid => 'System', :table_sid => 'dev_feedbacks', :action_sid => 'report_generate')
  Access.create(:app_sid => 'System', :table_sid => 'dev_feedbacks', :action_sid => 'report_load_labels')
  Access.create(:app_sid => 'System', :table_sid => 'dev_feedbacks', :action_sid => 'tree_list')
  Access.create(:app_sid => 'System', :table_sid => 'dev_feedbacks', :action_sid => 'tree_move')
  Access.create(:app_sid => 'System', :table_sid => 'dev_feedbacks', :action_sid => 'reporting')
  Access.create(:app_sid => 'System', :table_sid => 'dev_feedbacks', :action_sid => 'reporting_data')
  
  a = Access.all(:conditions => {:table_sid => 'translations'}).select{|a| a.action_sid.blank? && a.field_sid.blank?}.first
  if a
    if a.app_sid != 'System'
      a.app_sid = 'System'
      a.save
    end
  else
    Access.create(:app_sid => 'System', :table_sid => 'translations')
  end
  # Fields
  
  # Actions
  
  Access.create(:app_sid => 'System', :table_sid => 'translations', :action_sid => 'index')
  Access.create(:app_sid => 'System', :table_sid => 'translations', :action_sid => 'update')
  Access.create(:app_sid => 'System', :table_sid => 'translations', :action_sid => 'destroy')
  Access.create(:app_sid => 'System', :table_sid => 'translations', :action_sid => 'get_po')
  Access.create(:app_sid => 'System', :table_sid => 'translations', :action_sid => 'generation_status')
  Access.create(:app_sid => 'System', :table_sid => 'translations', :action_sid => 'generate_pos')
  Access.create(:app_sid => 'System', :table_sid => 'translations', :action_sid => 'delete_po')
  Access.create(:app_sid => 'System', :table_sid => 'translations', :action_sid => 'upload_po')
  
  end

  desc "Add Default Users / Profiles"
  task :add_profiles => :environment do
    
    if Profile.count == 0
      Profile.create(:name => "Faveod User")
      Profile.create(:name => "Admin")
      Profile.create(:name => "Logged In")
      Profile.create(:name => "Not Logged")
    end
    
  end
  
  desc "Clean source code files by removing useless files"
  task :clean_source_files => :environment do
    all_files = File.readlines(Rails.root.join('doc', 'source_code_files.txt')).reject{|l| l.blank? || l =~ /^#/}.map{|f| f.strip }
    puts "#{all_files.length} files should be in app"
    
    models_elts = all_files.grep(/^app\/models/).map{|f| File.basename(f) }
    models_pres = Dir[Rails.root.join("app", "models", "*")]
    models_to_rm = models_pres.reject {|f| models_elts.include?(File.basename(f)) }
    models_to_add = models_elts.reject{|e| models_pres.map{|f| File.basename(f)}.include?(e) }
    if models_to_rm.length > 0
      puts "Removing #{models_to_rm.length} from app/models, keeping #{models_elts.length}:"
      models_to_rm.sort.each do |f|
        puts "\tapp/models/#{File.basename(f)}"
        FileUtils.remove(f)
      end
    end
    if models_to_add.length > 0
      puts "#{models_to_add.sort.inspect} are missing from app/models !"
    end
    
    views_elts = all_files.grep(/^app\/views/).map{|f| File.basename(f) }
    views_pres = Dir[Rails.root.join("app", "views", "*")]
    views_to_rm = views_pres.reject {|f| views_elts.include?(File.basename(f)) }
    views_to_add = views_elts.reject{|e| views_pres.map{|f| File.basename(f)}.include?(e) }
    if views_to_rm.length > 0
      puts "Removing #{views_to_rm.length} from app/views, keeping #{views_elts.length}:"
      views_to_rm.sort.each do |f|
        puts "\tapp/views/#{File.basename(f)}"
        FileUtils.remove_dir(f)
      end
    end
    if views_to_add.length > 0
      puts "#{views_to_add.sort.inspect} are missing from app/views !"
    end
    
    controllers_elts = all_files.grep(/^app\/controllers/).map{|f| File.basename(f) }
    controllers_pres = Dir[Rails.root.join("app", "controllers", "*")]
    controllers_to_rm = controllers_pres.reject {|f| controllers_elts.include?(File.basename(f)) }
    controllers_to_add = controllers_elts.reject{|e| controllers_pres.map{|f| File.basename(f)}.include?(e) }
    if controllers_to_rm.length > 0
      puts "Removing #{controllers_to_rm.length} from app/controllers, keeping #{controllers_elts.length}:"
      controllers_to_rm.sort.each do |f|
        puts "\tapp/controllers/#{File.basename(f)}"
        FileUtils.remove(f)
      end
    end
    if controllers_to_add.length > 0
      puts "#{controllers_to_add.sort.inspect} are missing from app/controllers !"
    end
    
    helpers_elts = all_files.grep(/^app\/helpers/).map{|f| File.basename(f) }
    helpers_pres = Dir[Rails.root.join("app", "helpers", "*")]
    helpers_to_rm = helpers_pres.reject {|f| helpers_elts.include?(File.basename(f)) }
    helpers_to_add = helpers_elts.reject{|e| helpers_pres.map{|f| File.basename(f)}.include?(e) }
    if helpers_to_rm.length > 0
      puts "Removing #{helpers_to_rm.length} from app/helpers, keeping #{helpers_elts.length}:"
      helpers_to_rm.sort.each do |f|
        puts "\tapp/helpers/#{File.basename(f)}"
        FileUtils.remove(f)
      end
    end
    if helpers_to_add.length > 0
      puts "#{helpers_to_add.sort.inspect} are missing from app/helpers !"
    end
    
    apis_elts = all_files.grep(/^app\/apis/).map{|f| File.basename(f) }
    apis_pres = Dir[Rails.root.join("app", "apis", "*")]
    apis_to_rm = apis_pres.reject {|f| apis_elts.include?(File.basename(f)) }
    apis_to_add = apis_elts.reject{|e| apis_pres.map{|f| File.basename(f)}.include?(e) }
    if apis_to_rm.length > 0
      puts "Removing #{apis_to_rm.length} from app/apis, keeping #{apis_elts.length}:"
      apis_to_rm.sort.each do |f|
        puts "\tapp/apis/#{File.basename(f)}"
        FileUtils.remove(f)
      end
    end
    if apis_to_add.length > 0
      puts "#{apis_to_add.sort.inspect} are missing from app/apis !"
    end
    
    reports_elts = all_files.grep(/^app\/reports/).map{|f| File.basename(f) }
    reports_pres = Dir[Rails.root.join("app", "reports", "*")]
    reports_to_rm = reports_pres.reject {|f| reports_elts.include?(File.basename(f)) }
    reports_to_add = reports_elts.reject{|e| reports_pres.map{|f| File.basename(f)}.include?(e) }
    if reports_to_rm.length > 0
      puts "Removing #{reports_to_rm.length} from app/reports, keeping #{reports_elts.length}:"
      reports_to_rm.sort.each do |f|
        puts "\tapp/reports/#{File.basename(f)}"
        FileUtils.remove(f)
      end
    end
    if reports_to_add.length > 0
      puts "#{reports_to_add.sort.inspect} are missing from app/reports !"
    end
    
  end
end