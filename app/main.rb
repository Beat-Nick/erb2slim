require 'sinatra'
require 'json'
require 'slim'
require 'html2slim'
require 'html2haml'
require 'haml2slim'
require 'rack/mobile-detect'
require_relative 'data_client'
require 'pry'

####################
# Sinatra Config & Vars
####################
#set enviroment variables, cache if production
if settings.production?
	set :static_cache_control, [:public, max_age: 60 * 60 * 24 * 365]
end

#set views folder
#cat .\public\css\*.css | ac .\public\css\erb2slim.min.css
set :views, "views"

#initialize data client
data_client = DataClient.new(ENV["STORAGE"], ENV["STORAGE_KEY"])

#page conversion options & links
Conversions = 	{haml2slim: "ERB -> Haml -> Slim",
				 slim: "Slim",
				 haml: "Haml",
				 format: "HTML Formatter"}

Sites =   		{haml2slim: "https://github.com/slim-template/haml2slim",
				 html2slim: "https://github.com/slim-template/html2slim",
				 html2haml: "https://github.com/haml/html2haml",
				 nokogiri: "http://www.nokogiri.org/",
				 materialize: "http://materializecss.com/",
				 codemirror: "https://codemirror.net/"}

Advoptions = 	{erb: "Ignore ERB Tags",
				 xhtml: "Parse Stictly as XHTML",
				 ruby: "Ruby 1.9 Tags If Possible",
				 indent: "Set Indent to 4"}

####################
# Device Detection & Render
####################
use Rack::MobileDetect

get '/' do
	isdev = settings.development?
	pageload_conversions = data_client.get_count().to_s.rjust(7, "0") #add leading zeros
	if !request.env['X_MOBILE_DEVICE']
    	slim :index, :locals => {:conversions => Conversions, :sites => Sites, :advoptions => Advoptions, :isdev => isdev, :conversion_cnt => pageload_conversions}
	else
		slim :mobile, :layout => :layout_mobile, :locals => {:isdev => isdev}
	end
end

####################
# Conversion
####################
post '/convert.json' do
	raw_text = params[:raw_text]
	conversion_type = params[:conversion_type]
	params[:erb].nil? ? erb = true : erb = false
	params[:xhtml].nil? ? xhtml = false : xhtml = true
	params[:ruby].nil? ? ruby = false : ruby = true
	params[:indent].nil? ? indent = 2 : indent = 4

	options = {erb: erb,xhtml: xhtml,ruby: ruby,indent: indent}

	converted_txt = convert(raw_text, conversion_type, options)

	#bump conversion count (add leading zeros for counter)
	conversion_count = data_client.incr_count().to_s.rjust(7, "0")

	#return data as json
	content_type :json
	{:converted_txt => converted_txt, :conversion_cnt => conversion_count}.to_json
end

def convert(raw_text, conversion_type, options)
	begin
		case conversion_type
		when "slim"
			converted_txt = HTML2Slim.convert!(raw_text, conversion_type).to_s
		when "haml2slim"
			options = {erb: options[:erb], xhtml: options[:xhtml], ruby19_style_attributes: options[:ruby]}
			converted_txt = Html2haml::HTML.new(raw_text, options).render
			converted_txt = Haml2Slim.convert!(converted_txt).to_s
		when "haml"
			options = {erb: options[:erb], xhtml: options[:xhtml], ruby19_style_attributes: options[:ruby]}
			converted_txt = Html2haml::HTML.new(raw_text, options).render
		when "format"
			converted_txt = Nokogiri::HTML(raw_text).to_xhtml(indent: options[:indent])
		else
			converted_txt = "Converter not found!"
		end
	rescue Exception => e
		return e.to_s
	end

	return converted_txt
end