require 'bundler'
Bundler.require
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
DataMapper::setup(:default, ENV['DATABASE_URL'] || "sqlite3:nanban.db")
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
