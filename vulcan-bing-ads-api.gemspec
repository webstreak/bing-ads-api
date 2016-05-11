$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "bing-ads-api/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
	s.name        = "vulcan-bing-ads-api"
	s.version     = BingAdsApi::VERSION
	s.authors     = ["Colin Knox", "Alexander Cavalli"]
	s.email       = ["colin.knox@offers.com"]
	s.homepage    = "https://github.com/info-sys/bing-ads-api"
	s.summary     = "Bing Ads API for Ruby"
	s.description = "A set of pure Ruby classes for the Bing Ads API"

	s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.rdoc"]
	s.test_files = Dir["spec/**/*"]

	s.add_dependency "savon", "~> 2.5"
	s.add_dependency "rest-client"
	s.add_dependency "activesupport"

	s.add_development_dependency "rspec", "< 3.0"
	s.add_development_dependency "guard"
	s.add_development_dependency "guard-rspec"
end
