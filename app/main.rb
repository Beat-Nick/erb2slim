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
	conversions = ["haml2slim", "slim", "haml"]
	sites =   { html2slim: "https://github.com/slim-template/html2slim",
			 	html2haml: "https://github.com/haml/html2haml",
			 	haml2slim: "https://github.com/slim-template/haml2slim",
			 	materialize: "http://materializecss.com/",
			 	codemirror: "https://codemirror.net/"}
	advoptions = {erb: "Ignore ERB Tags",
				  xhtml: "Output XHTML",
				  ruby: "Ruby 1.9 Tags If Possible"}
    slim :index, :locals => {:conversions => conversions, :sites => sites, :advoptions => advoptions}
end

post '/convert.json' do
	raw_text = params[:raw_text]
	conversion_type = params[:conversion_type]
	params[:erb].nil? ? erb = false : erb = true
	params[:xhtml].nil? ? xhtml = false : xhtml = true
	params[:ruby].nil? ? ruby = false : ruby = true

	options = [erb,xhtml,ruby]

	converted_txt = convert(raw_text, conversion_type, options)

	content_type :json 
	{:converted_txt => converted_txt}.to_json
end

def convert(raw_text, conversion_type, options)
	begin
		case conversion_type
		when "slim"
			converted_txt = HTML2Slim.convert!(raw_text, conversion_type).to_s
		when "haml2slim"
			options = {:erb => options[0], :xhtml => options[1], :ruby19_style_attributes => options[2]}
			converted_txt = Html2haml::HTML.new(raw_text, options).render
			converted_txt = Haml2Slim.convert!(converted_txt).to_s
		when "haml"
			options = {:erb => options[0], :xhtml => options[1], :ruby19_style_attributes => options[2]}
			converted_txt = Html2haml::HTML.new(raw_text, options).render
		else 
			converted_txt = "Converter not found!"
		end
	rescue Exception => e
		return e.to_s
	end	

	return converted_txt
end

