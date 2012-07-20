$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "rubyception/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "rubyception"
  s.version     = Rubyception::VERSION
  s.authors     = ["TODO: Your name"]
  s.email       = ["TODO: Your email"]
  s.homepage    = "TODO"
  s.summary     = "TODO: Summary of Rubyception."
  s.description = "TODO: Description of Rubyception."

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency 'rails'
  s.add_dependency 'haml'
  s.add_dependency 'sass'
  s.add_dependency 'jenny'
  s.add_dependency 'em-websocket'
  s.add_dependency 'compass'
  s.add_dependency 'coffee-script'
  s.add_development_dependency "sqlite3"
end
