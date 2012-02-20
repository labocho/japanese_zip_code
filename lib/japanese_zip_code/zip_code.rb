require "active_record"
# 郵便番号で町名が一意に決まらない場合(col13==1、 col10==1)は、 street と street_rubi は NULL
module JapaneseZipCode
  class ZipCode < ActiveRecord::Base
    validates_presence_of :zip, :prefecture_phonetic, :city_phonetic, :prefecture, :city

    def self.lookup(zip)
      return if zip.blank?
      zip = zip.gsub(/[^\d]/, "")
      case zip
      when /\A\d{7}\z/
        where(zip: zip).first
      else
        where(zip5: zip.ljust(5, " ")).first
      end
    end
  end
end
