source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

gem 'sinatra'
gem 'haml'
gem 'mechanize'
gem 'redis'
gem 'twitter', github: 'sferik/twitter', ref: '844818'
gem 'thin'
gem 'dotenv'
gem 'nicosa'
gem 'chrono'
