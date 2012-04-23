# encoding: UTF-8
require "csv"
require "tempfile"

module JapaneseZipCode
  module Updater
    SOURCE_URL = "http://www.post.japanpost.jp/zipcode/dl/kogaki/zip/ken_all.zip"
    SOURCE = File.expand_path "#{File.dirname(__FILE__)}/../../data/japanese_zip_code/KEN_ALL.CSV"

    module_function
    def update_csv(url = SOURCE_URL)
      raise "`curl` not found!" unless system("which curl", out: "/dev/null")
      raise "`unzip` not found!" unless system("which unzip", out: "/dev/null")

      temp = Tempfile.new("ken_all.zip")
      temp.close

      unless system(%!curl "#{SOURCE_URL}" > #{temp.path}!, out: STDOUT, err: STDERR)
        raise "curl Failed!"
      end

      unless system(%!unzip -o #{temp.path} -d "#{File.dirname(SOURCE)}"!, out: STDOUT, err: STDERR)
        raise "unzip Failed!"
      end
    end

    def update_table(csv = SOURCE)
      raise "Zip code source file not found: #{csv}" unless File.exists?(csv)

      # テーブルを空にする
      puts "Initialize table.."
      begin
        ZipCode.connection.execute "TRUNCATE #{ZipCode.connection.quote_table_name(ZipCode.table_name)}"
      rescue
        ZipCode.connection.execute "DELETE FROM #{ZipCode.connection.quote_table_name(ZipCode.table_name)}"
      end

      csv_options = {
        encoding: "Shift_JIS:UTF-8",
        col_sep: ",",
        row_sep: "\r\n"
      }

      success = 0
      failure = 0
      CSV.foreach(csv, csv_options) do |row|
        zip_code = ZipCode.new(
          organization_code: row[0],
          zip5: row[1].strip,
          zip: row[2],
          prefecture_phonetic: normalize(row[3]),
          city_phonetic: normalize(row[4]),
          street_phonetic: normalize(filter_street(row[5])),
          prefecture: normalize(row[6]),
          city: normalize(row[7]),
          street: normalize(filter_street(row[8])),
        )

        if zip_code.save
          success += 1
        else
          failure += 1
          puts "#{zip_code.zip} creation failed."
          p zip_code.errors
        end
        if (success + failure) % 1000 == 0
          puts "#{(success + failure)} lines processed."
        end
      end

      puts "Complete! #{success} success. #{failure} failure."
    end

    def normalize(str)
      Charwidth.normalize(str) if str
    end

    def filter_street(str)
      return if str == "以下に掲載がない場合"
      return if str == "ｲｶﾆｹｲｻｲｶﾞﾅｲﾊﾞｱｲ"
      str
    end
  end
end
