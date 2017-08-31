require "japanese_zip_code/version"

module JapaneseZipCode
  autoload :Updater, "japanese_zip_code/updater"
  autoload :ZipCode, "japanese_zip_code/zip_code"
  require "japanese_zip_code/railtie" if defined?(Rails)
end
