# 771-2102 のstreetがstringに納まらないため変更
class ModifyZipCodesStreet < ActiveRecord::Migration
  def up
    change_column :zip_codes, :street, :text
    change_column :zip_codes, :street_phonetic, :text
  end

  # def down
  #   change_column :zip_codes, :street, :string
  #   change_column :zip_codes, :street_phonetic, :string
  # end
end