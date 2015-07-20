require 'sinatra'
require 'json'
require 'slim'
require 'html2slim'
require 'html2haml'

set :environment, :production
set :port, '80'
set :static, true
set :views, "views"

get '/' do
		conversions = ["erb", "haml", "html"]
    slim :index, :locals => {:conversions => conversions}
end

get '/convert.json' do
		raw_text = params[:raw_text]
		conversion_type = params[:convert_type]
		
		if conversion_method == 'erb'
			converted_text = HTML2Slim.convert!(raw_text, conversion_type)
		else 
			converted_text = "something went wrong"
		end
		
		content_type :json 
		{:converted_txt => converted_txt}.to_json
end
