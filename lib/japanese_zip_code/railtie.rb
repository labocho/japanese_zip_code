require "japanese_zip_code"
require "rails"

module JapaneseZipCode
  class Railtie < Rails::Railtie
    railtie_name :japanese_zip_code
    rake_tasks do
      load "tasks/japanese_zip_code.rake"
    end
  end
end
