require File.expand_path('../lib/omniauth-zendesk-oauth2/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors = ["Jonas Oberschweiber"]
  gem.email = "jonas.oberschweiber@d-velop.de"
  gem.description = %q{OmniAuth Strategy for Zendesk via OAuth2}
  gem.summary = %q{OmniAuth Strategy for Zendesk via OAuth2}
  gem.homepage = "https://github.com/jonasoberschweiber/omniauth-zendesk-oauth2"

  gem.name = "omniauth-zendesk-oauth2"
  gem.files = `git ls-files`.split("\n")
  gem.require_paths = ["lib"]
  gem.version = OmniAuth::Zendesk::VERSION

  gem.add_dependency 'omniauth', '~> 1.0'
  gem.add_dependency 'omniauth-oauth2', '~> 1.1'
  gem.add_development_dependency 'rspec'
end
