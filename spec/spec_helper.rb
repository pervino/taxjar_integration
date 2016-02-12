require 'simplecov'
SimpleCov.start do
  add_filter 'spec'
end
require 'rubygems'
require 'bundler'
require "pstore"

require 'spree/testing_support/controllers'

Bundler.require(:default, :test)

ENV['ENDPOINT_KEY'] = 'x123'
ENV['RACK_ENV'] = 'test'

require File.join(File.dirname(__FILE__), '..', 'lib/taxjar_integration')
require File.join(File.dirname(__FILE__), '..', 'taxjar_endpoint')
Dir["./spec/support/**/*.rb"].each { |f| require f }

module RSpecMixin
  include Rack::Test::Methods

  def app
    TaxjarEndpoint
  end
end

VCR.configure do |c|
  c.allow_http_connections_when_no_cassette = true
  c.cassette_library_dir = 'spec/vcr_cassettes'
  c.hook_into :webmock

  c.filter_sensitive_data('taxjar_api_key') { |_| ENV['TAXJAR_API_KEY'] }
end

RSpec.configure do |config|
  config.include Spree::TestingSupport::Controllers
  config.include RSpecMixin
end