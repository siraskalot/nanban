require 'sinatra'
require 'data_mapper'
require 'sqlite3'
require 'dm-sqlite-adapter'
require 'time'

# Models
class Event
  include DataMapper::Resource
  property :id,           Serial
  property :time,         DateTime
  property :type,         String
  property :description,  String
end

# Persistance
DataMapper::setup(:default, "sqlite3:nanban.db")
DataMapper.finalize.auto_upgrade!

# Controllers/Routes
get '/' do
  @events = Event.all(:order => :time.desc)
  erb :index
end

get '/new/?' do
  erb :new
end

post '/new/?' do
  begin
    Event.create(
      :time         => Time.parse(Time.now.strftime('%Y-%m-%d %H:%M:%S')),
      :type         => params['type'],
      :description  => params['description']
    )
    redirect '/'
  rescue
      erb :new
  end
end
