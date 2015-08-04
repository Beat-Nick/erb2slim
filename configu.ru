require 'rubygems'
require 'sinatra'

#set :environment, ENV['RACK_ENV'].to_sym
#disable :run, :reload

#require File.expand_path '../app/main.rb', __FILE__

require './main.rb'

run Sinatra::Application