ENV['RACK_ENV'] = 'test'
require 'rack/test'
require_relative '../lib/melodiest'

RSpec.configure do |config|
  config.include Rack::Test::Methods

  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  begin
    config.filter_run :focus
    config.run_all_when_everything_filtered = true

    #config.disable_monkey_patching!
    config.warnings = false

    if config.files_to_run.one?
      config.default_formatter = 'doc'
    end

    config.profile_examples = 10
    config.order = :random

    Kernel.srand config.seed
  end
end

class SpecApp < Melodiest::Application
  cookie_secret 'supersecretcookiespec'
end

def app
  SpecApp
end

def gem_root_path
  File.expand_path "../../", __FILE__
end

