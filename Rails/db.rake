# lib/tasks/db.rake
namespace :db do

  desc "Dumps the database to db/APP_NAME.dump"
  task :dump => :environment do
    cmd = nil

    directory_name = "#{Rails.root}/db/backups"
    Dir.mkdir(directory_name) unless File.exists?(directory_name)
    
    with_config do |app, host, db, user|
      date = Time.current.strftime("%d.%m.%Y")
      cmd = "pg_dump --host #{host} --username #{user} --no-password --no-owner --column-inserts #{db} > #{Rails.root}/db/backups/#{date}_#{app}.sql"
    end
    puts cmd
    exec cmd
  end

  desc "Restores the database dump at db/APP_NAME.dump."
  task :restore => :environment do
    cmd = nil
    with_config do |app, host, db, user|
      cmd = "pg_restore --verbose --host #{host} --username #{user} --clean --no-owner --no-acl --dbname #{db} #{Rails.root}/db/#{app}.dump"
    end
    Rake::Task["db:drop"].invoke
    Rake::Task["db:create"].invoke
    puts cmd
    exec cmd
  end

  private

  def with_config
    yield Rails.application.class.parent_name.underscore,      
      ActiveRecord::Base.connection_config[:host] = 'localhost',
      ActiveRecord::Base.connection_config[:database] = 'sgcli',
      ActiveRecord::Base.connection_config[:username] = 'bergson'
  end

end