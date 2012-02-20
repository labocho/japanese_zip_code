require "rails/generators/active_record"
module JapaneseZipCode
  class JapaneseZipCodeGenerator < Rails::Generators::Base
    include Rails::Generators::Migration
    namespace "japanese_zip_code"
    source_root File.expand_path "#{File.dirname(__FILE__)}/../templates"

    def create_migration_file
      migration_template "create_zip_codes.rb", "db/migrate/create_zip_codes"
    end

    def self.next_migration_number(dirname)
      ActiveRecord::Generators::Base.next_migration_number(Rails.root + "db/migrate")
    end
  end
end
