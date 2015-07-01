#
# CSVファイルの仕様
#
# 1. 全国地方公共団体コード(JIS X0401、X0402)……… 半角数字
# 2. (旧)郵便番号(5桁)……………………………………… 半角数字
# 3. 郵便番号(7桁)……………………………………… 半角数字
# 4. 都道府県名 ………… 半角カタカナ(コード順に掲載) (注1)
# 5. 市区町村名 ………… 半角カタカナ(コード順に掲載) (注1)
# 6. 町域名 ……………… 半角カタカナ(五十音順に掲載) (注1)
# 7. 都道府県名 ………… 漢字(コード順に掲載) (注1,2)
# 8. 市区町村名 ………… 漢字(コード順に掲載) (注1,2)
# 9. 町域名 ……………… 漢字(五十音順に掲載) (注1,2)
# 10. 一町域が二以上の郵便番号で表される場合の表示 (注3) (「1」は該当、「0」は該当せず)
# 11. 小字毎に番地が起番されている町域の表示 (注4) (「1」は該当、「0」は該当せず)
# 12. 丁目を有する町域の場合の表示 (「1」は該当、「0」は該当せず)
# 13. 一つの郵便番号で二以上の町域を表す場合の表示 (注5) (「1」は該当、「0」は該当せず)
# 14. 更新の表示（注6）（「0」は変更なし、「1」は変更あり、「2」廃止（廃止データのみ使用））
# 15. 変更理由 (「0」は変更なし、「1」市政・区政・町政・分区・政令指定都市施行、「2」住居表示の実施、「3」区画整理、「4」郵便区調整等、「5」訂正、「6」廃止(廃止データのみ使用))

class CreateZipCodes < ActiveRecord::Migration
  def self.up
    create_table :zip_codes do |t|
      t.string :organization_code, :limit => 6, :null => false
      t.string :zip5, :limit => 5
      t.string :zip, :limit => 7, :null => false
      t.string :prefecture_phonetic, :null => false
      t.string :city_phonetic, :null => false
      t.string :street_phonetic
      t.string :prefecture, :null => false
      t.string :city, :null => false
      t.string :street
      # t.bool :street_has_multi_codes, :limit => 1, :null => false
      # t.bool :require_koaza, :limit => 1, :null => false
      # t.bool :require_chome, :limit => 1, :null => false
      # t.bool :has_multi_street, :limit => 1, :null => false
      # t.integer :update, :limit => 1, :null => false
      # t.integer :update_reason, :limit => 1, :null => false

      t.timestamps null: false
    end

    add_index :zip_codes, :organization_code
    add_index :zip_codes, :zip
  end

  def self.down
    drop_table :zip_codes
  end
end
