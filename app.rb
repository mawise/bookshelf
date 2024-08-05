require 'sinatra'
require 'rmagick'
require_relative 'calibre.rb'

## setup
bookdir = ARGV[0]
raise "Please specify a Calibre library directory as a parameter when running this server" if bookdir.nil?
CalibreBook.connect(bookdir)
books = CalibreBook.some_books(15)

## endpoints

get '/' do
  @books = books
  erb :index
end

get '/download/*' do
  filepath = params['splat'].first
  puts "trying to send_file for #{filepath}"
  send_file "/#{filepath}"
end
