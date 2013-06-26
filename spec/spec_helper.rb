require 'rubygems'
require 'bundler/setup'
Bundler.require(:default)

require 'webmock/rspec'
require 'vcr'
include WebMock::API
VCR.configure do |c|
  c.cassette_library_dir     = 'spec/cassettes'
  c.hook_into                :webmock
  c.default_cassette_options = { :record => :once }
  c.allow_http_connections_when_no_cassette = true
end

RSpec.configure do |config|
  config.treat_symbols_as_metadata_keys_with_true_values = true
  config.run_all_when_everything_filtered = true
end
