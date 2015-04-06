require 'httparty'
require 'nokogiri'
require 'json'
require 'sinatra'
require "rack-cache"

require './lib/haiku'
require './lib/social_image'

def text_for_url(url: '', css_selector: 'p')
	Nokogiri::HTML(
		HTTParty.get(url).body
	).css(css_selector).text
end

helpers do
	def json_and_escape text
		URI.escape(
			JSON.generate(text), 
			Regexp.new("[^#{URI::PATTERN::UNRESERVED}]")
		)
	end
end

get '/' do
	@app_url = "#{request.scheme}://#{request.host_with_port}"
	erb :index
end

get '/haiku' do
	if ENV['RACK_ENV'] == 'production'
		cache_control :public, max_age: 60
	end

	url = CGI.unescape(params[:url])
	puts "haiku-ing url=#{url}"

	@text = text_for_url(url: url)
	@haiku = Haiku.new.search(text: @text)

	@app_url = "#{request.scheme}://#{request.host_with_port}"

	erb :haiku
end

get '/share' do
	@app_url = "#{request.scheme}://#{request.host_with_port}"
	@full_url = request.url
	@text = JSON.parse CGI.unescape(params[:text])
	erb :share
end

get '/share-image' do
	if ENV['RACK_ENV'] == 'production'
		cache_control :public, max_age: 60
	end

	@app_url = "#{request.scheme}://#{request.host_with_port}"
	@text = JSON.parse CGI.unescape(params[:text])
	# @url  = CGI.unescape(params[:url])
	
	send_file SocialImage.new.build(text: @text), type: 'image/png', disposition: 'inline'
	
end