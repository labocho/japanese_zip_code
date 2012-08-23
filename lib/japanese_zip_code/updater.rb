# encoding: UTF-8
require "csv"
require "tempfile"
require "charwidth"

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

      zip_code = nil
      CSV.foreach(csv, csv_options) do |row|
        zip_code_temp = ZipCode.new(
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

        if @street_continue || @street_phonetic_continue
          # 継続行が street / street_phonetic 以外は一致するか調べる
          # もし一致しなければ継続行との判断はミスなので例外
          %w(organization_code zip5 zip prefecture_phonetic city_phonetic prefecture city).each do |a|
            unless zip_code[a] == zip_code_temp[a]
              raise "Continuous line is invalid:\n  #{zip_code.inspect}\n  #{zip_code_temp.inspect}"
            end
          end

          # 漢字表記は分割していても読みは分割していない (すべて同じ値が入る) 場合があるため
          # 個別に処理する
          zip_code.street << zip_code_temp.street if @street_continue
          zip_code.street_phonetic << zip_code_temp.street_phonetic if @street_phonetic_continue
        else
          zip_code = zip_code_temp
        end

        # まだ継続行があるか調べ、あれば next
        @street_continue = street_continue?(zip_code)
        @street_phonetic_continue = street_phonetic_continue?(zip_code)
        next if @street_continue || @street_phonetic_continue

        # もう継続行がないので保存
        if zip_code.save!
          success += 1
        else
          failure += 1
          puts "#{zip_code.zip} creation failed."
          p zip_code.errors
        end
        if (success + failure) % 1000 == 0
          puts "#{(success + failure)} lines processed."
        end
        zip_code = nil
        @street_continue = nil
        @street_phonetic_continue = nil
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

    # street に () があり、対応がとれていなければ true
    def street_continue?(zip_code)
      s = zip_code.street
      return true if s && (s.gsub(/[^\(]/, "").size != s.gsub(/[^\)]/, "").size)
      false
    end

    # street_phonetic に () があり、対応がとれていなければ true
    def street_phonetic_continue?(zip_code)
      s = zip_code.street_phonetic
      return true if s && (s.gsub(/[^\(]/, "").size != s.gsub(/[^\)]/, "").size)
      false
    end
  end
end
