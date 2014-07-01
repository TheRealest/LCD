require 'rubygems'
require 'bundler/setup'
require 'sinatra/base'
require 'haml'

require_relative './middleware/sass_handler'
require_relative '../src/set_dsl'
require_relative '../sets/cold_war.set'

class Application < Sinatra::Base
	use SassHandler

	set :port, 1337

	get "/" do
		"Hello world! The time is now #{Time.now}!"
	end

	get "/generate/?:set?/?:n?" do
		if params[:set] && params[:n]
			clear :characters
			set params[:set]
			generate params[:n]


			@title = "LCD - #{params[:set]} - #{params[:n]} characters"
			@chars = get(:characters)
			haml :generate
			# @chars.inject("") do |str,char|
			# 	str << char.to_s
			# 	str << "<br />\n"
			# end
		else
			"What would you like to generate?"
		end

	end
end
