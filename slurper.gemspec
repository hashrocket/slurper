# -*- encoding: utf-8 -*-

Gem::Specification.new do |gem|
  gem.name = "slurper"
  gem.version = "1.1.8"
  gem.license = "MIT"

  gem.authors = ["Hashrocket"]
  gem.default_executable = 'slurp'
  gem.description = "Slurps stories from the given file (stories.slurper by default) and creates Pivotal Tracker stories from them. Useful during story carding sessions when you want to capture a number of stories quickly without clicking your way through the Tracker UI."
  gem.email = "dev@hashrocket.com"
  gem.executables = ["slurp"]
  gem.extra_rdoc_files = ["README.rdoc"]
  gem.files = Dir.glob("lib/**/*") + %w(bin/slurp MIT_LICENSE README.rdoc Rakefile)
  gem.homepage = "http://github.com/hashrocket/slurper"
  gem.rdoc_options = ["--charset=UTF-8"]
  gem.require_path = "lib"
  gem.summary = "takes a formatted story file and puts it on Pivotal Tracker"

  gem.add_dependency("activeresource", ["~> 3.0.9"])
end
