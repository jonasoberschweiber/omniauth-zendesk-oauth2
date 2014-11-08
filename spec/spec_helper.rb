$:.unshift File.expand_path('..', __FILE__)
$:.unshift File.expand_path('../../lib', __FILE__)

require 'rspec'
require 'omniauth'
require 'omniauth-zendesk-oauth2'

RSpec.configure do |config|
  config.extend OmniAuth::Test::StrategyMacros, type: :strategy
end
