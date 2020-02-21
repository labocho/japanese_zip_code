# encoding: UTF-8
namespace :japanese_zip_code do
  desc "Update zip code csv and table"
  task :update => [:update_csv, :update_table]

  desc "Update zip_codes table"
  task :update_table => :environment do
    JapaneseZipCode::Updater.update_table
  end

  desc "Update zip code csv file"
  task :update_csv do
    JapaneseZipCode::Updater.update_csv
  end
end
