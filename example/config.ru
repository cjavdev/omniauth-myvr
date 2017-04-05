# Sample app for MyVR OAuth Strategy
# Make sure to setup the ENV variables MYVR_KEY and MYVR_SECRET
# Run with "bundle exec rackup"

require 'rubygems'
require 'bundler'
require 'sinatra'
require 'omniauth'
require '../lib/omniauth_myvr'

ENV['MYVR_KEY'] = '811f088e585dd0e4beaba9e758059f02'
ENV['MYVR_SECRET'] = '6e33b7189bc37bdeb571f94c366b6ef5'
# Do not use for production code.
# This is only to make setup easier when running through the sample.
#
# If you do have issues with certs in production code, this could help:
# http://railsapps.github.io/openssl-certificate-verify-failed.html
OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE

class App < Sinatra::Base
  get '/' do
    <<-HTML
    <ul>
      <li><a href='/auth/myvr'>Sign in with MyVR</a></li>
    </ul>
    HTML
  end

  get '/auth/:provider/callback' do
    content_type 'text/plain'
    request.env['omniauth.auth'].to_hash.inspect rescue "No Data"
  end

  get '/auth/failure' do
    content_type 'text/plain'
    request.env['omniauth.auth'].to_hash.inspect rescue "No Data"
  end
end

use Rack::Session::Cookie, :secret => ENV['RACK_COOKIE_SECRET']

use OmniAuth::Builder do
  provider :myvr, ENV['MYVR_KEY'], ENV['MYVR_SECRET'], {
    scope: 'rate_read'
  }
end

run App.new
