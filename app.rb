require 'sinatra'
require_relative 'calibre.rb'
require_relative 'logos.rb'

## setup
bookdir = ARGV[0]
raise "Please specify a Calibre library directory as a parameter when running this server" if bookdir.nil?
CalibreBook.connect(bookdir)
books = CalibreBook.some_books(15)

## endpoints

get '/' do
  @books = CalibreBook.some_books(25)
  erb :index
end

get '/author/:query' do
  @books = CalibreBook.search_author params['query']
  erb :index
end

get '/series/:query' do
  @books = CalibreBook.search_series params['query']
  erb :index
end

get '/download/*' do
  filepath = "/" + params['splat'].first
  filepath.gsub!("/../","/") # try to avoid exposing the whole filesystem, probably not good enough
  puts "DEBUG getting #{filepath}"
  if filepath.start_with? bookdir
    send_file filepath
  else
    raise Sinatra::NotFound
  end
end
