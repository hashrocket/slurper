# -*- encoding: utf-8 -*-

Gem::Specification.new do |gem|
  gem.name = "slurper"
  gem.version = "2.1.0"
  gem.license = "MIT"

  gem.authors = ["Adam Lowe", "Paul Elliott", "Taylor Mock", "Chris Erin"]
  gem.description = "Slurps stories from the given file (stories.slurper by default) and creates Pivotal Tracker stories from them. Useful during story carding sessions when you want to capture a number of stories quickly without clicking your way through the Tracker UI."
  gem.email = "dev@hashrocket.com"
  gem.executables = ["slurp"]
  gem.files = Dir.glob("lib/**/*") + %w(bin/slurp MIT_LICENSE README.md Rakefile)
  gem.homepage = "http://github.com/hashrocket/slurper"
  gem.rdoc_options = ["--charset=UTF-8"]
  gem.require_path = "lib"
  gem.summary = "takes a formatted story file and puts it on Pivotal Tracker"

  gem.add_dependency("activesupport", ["~> 5.2"])
  gem.add_dependency("typhoeus", ["~> 0.6"])
end
