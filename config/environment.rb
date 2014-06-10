# Load the Rails application.
require File.expand_path('../application', __FILE__)

# require 'mongo'
# require 'uri'

# def get_connection
#   return @db_connection if @db_connection
#   db = URI.parse(ENV['MONGOHQ_URL'])
#   db_name = db.path.gsub(/^\//, '')
#   @db_connection = Mongo::Connection.new(db.host, db.port).db(db_name)
#   @db_connection.authenticate(db.user, db.password) unless (db.user.nil? || db.user.nil?)
#   @db_connection
# end

# db = get_connection

# Initialize the Rails application.
Rails.application.initialize!
