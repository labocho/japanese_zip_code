# encoding: utf-8

require 'rubygems'
require 'bundler'
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end
require 'rake'

require 'jeweler'
require "#{File.dirname(__FILE__)}/lib/japanese_zip_code/version"
Jeweler::Tasks.new do |gem|
  # gem is a Gem::Specification... see http://docs.rubygems.org/read/chapter/20 for more options
  gem.name = "japanese_zip_code"
  gem.version = JapaneseZipCode::VERSION
  gem.homepage = "http://github.com/labocho/japanese_zip_code"
  gem.license = "MIT"
  gem.summary = %Q{Ruby on Rails plugin to store and lookup japanese zip code}
  gem.description = %Q{japanese_zip_code is Ruby on Rails plugin to store and lookup japanese zip code and associated address.}
  gem.email = "labocho@penguinlab.jp"
  gem.authors = ["labocho"]
  # dependencies defined in Gemfile
end
Jeweler::RubygemsDotOrgTasks.new

require 'rspec/core'
require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec) do |spec|
  spec.pattern = FileList['spec/**/*_spec.rb']
end

RSpec::Core::RakeTask.new(:rcov) do |spec|
  spec.pattern = 'spec/**/*_spec.rb'
  spec.rcov = true
end

task :default => :spec

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "japanese_zip_code #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
