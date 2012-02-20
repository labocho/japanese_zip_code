module JapaneseZipCode
  autoload :VERSION, "japanese_zip_code/version"
  autoload :Updater, "japanese_zip_code/updater"
  autoload :ZipCode, "japanese_zip_code/zip_code"
end

load "tasks/japanese_zip_code.rake" if defined? Rake
