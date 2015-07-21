require 'sinatra'
require 'json'
require 'slim'
require 'html2slim'
require 'html2haml'
require 'haml2slim'
require 'pry'

set :environment, :production
set :port, '80'
set :static, true
set :views, "views"

get '/' do
	conversions = ["haml->slim", "slim", "haml"]
    slim :index, :locals => {:conversions => conversions}
end

post '/convert.json' do
	raw_text = params[:raw_text]
	conversion_type = params[:conversion_type]

	converted_txt = convert(raw_text, conversion_type)

	content_type :json 
	{:converted_txt => converted_txt}.to_json
end

def convert(raw_text, conversion_type)
	begin
		case conversion_type
		when "slim"
			converted_txt = HTML2Slim.convert!(raw_text, conversion_type).to_s
		when "haml->slim"
			options = {:erb => true, :xhtml => false}
			converted_txt = Html2haml::HTML.new(raw_text, options).render
			converted_txt = Haml2Slim.convert!(converted_txt).to_s
		when "haml"
			options = {:erb => true, :xhtml => false}
			converted_txt = Html2haml::HTML.new(raw_text, options).render
		else 
			converted_txt = "Converter not found!"
		end
	rescue Exception => e
		return e.to_s
	end	

	return converted_txt
end

