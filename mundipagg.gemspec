$:.push File.expand_path("../lib", __FILE__)
require "mundipagg/version"

Gem::Specification.new do |s|
  s.name = "mundipagg"
  s.summary = "MundiPagg Ruby Client Library"
  s.description = "Ruby library for integrating with the MundiPagg payment web services"
  s.version = Mundipagg::Version::String
  s.author = "MundiPagg"
  s.email = "github@mundipagg.com"
  s.files = Dir.glob ["README.md", "LICENSE", "lib/**/*.{rb}", "tests/**/*", "*.gemspec"]
  s.homepage = "https://github.com/mundipagg/mundipagg-ruby-api"
  s.extra_rdoc_files = [
    "LICENSE",
    "README.md"
  ]
  s.add_dependency "savon", "2.3.0"
  s.required_ruby_version = '>= 1.9.2'
  s.license = "Apache 2.0"
  

end
