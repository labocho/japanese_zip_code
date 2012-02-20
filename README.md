# japanese\_zip\_code

japanese\_zip\_code is Ruby on Rails plugin to store and lookup japanese zip code and associated address.

# Instllation

Edit Gemfile

    #Gemfile
    gem "japanese_zip_code"

and enter command below.

    bundle install
    rails generate japanese_zip_code
    rake db:migrate

# Initialize / Updating

    rake japanese_zip_code:update

# Usage

    JapaneseZipCode::ZipCode.lookup("060-0000")
    # #<JapaneseZipCode::ZipCode
    #   id: 1,
    #   organization_code: "01101",
    #   prefecture: "北海道",
    #   city: "札幌市中央区",
    #   street: "以下に掲載がない場合",
    #   zip: "0600000",
    #   zip5: "060  ",
    #   prefecture_phonetic: "ﾎｯｶｲﾄﾞｳ",
    #   city_phonetix: "ｻｯﾎﾟﾛｼﾁｭｳｵｳｸ"
    #   street_phonetic: "ｲｶﾆｹｲｻｲｶﾞﾅｲﾊﾞｱｲ"
    # ...
    # >

# Contributing to japanese\_zip\_code

* Check out the latest master to make sure the feature hasn't been implemented or the bug hasn't been fixed yet
* Check out the issue tracker to make sure someone already hasn't requested it and/or contributed it
* Fork the project
* Start a feature/bugfix branch
* Commit and push until you are happy with your contribution
* Make sure to add tests for it. This is important so I don't break it in a future version unintentionally.
* Please try not to mess with the Rakefile, version, or history. If you want to have your own version, or is otherwise necessary, that is fine, but please isolate to its own commit so I can cherry-pick around it.

# Copyright

Copyright (c) 2012 labocho. See LICENSE.txt for
further details.
