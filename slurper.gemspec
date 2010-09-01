# -*- encoding: utf-8 -*-

require 'bundler'

Gem::Specification.new do |s|
  s.name = %q{slurper}
  s.version = "0.4.3"

  s.required_rubygems_version = "= 1.3.6"
  s.authors = ["Wes Gibbs", "Adam Lowe", "Stephen Caudill", "Tim Pope"]
  s.date = %q{2010-08-31}
  s.default_executable = %q{slurp}
  s.description = %q{
      Slurps stories from the given file (stories.slurper by default) and creates
      Pivotal Tracker stories from them. Useful during story carding sessions
      when you want to capture a number of stories quickly without clicking
      your way through the Tracker UI.
    }
  s.email = %q{dev@hashrocket.com}
  s.executables = ["slurp"]
  s.extra_rdoc_files = [
    "README.rdoc"
  ]
  s.files = [
    "bin/slurp",
     "lib/slurper.rb",
     "lib/story.rb"
  ]
  s.homepage = %q{http://github.com/hashrocket/slurper}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.summary = %q{takes a formatted story file and puts it on Pivotal Tracker}
  s.test_files = [
    "spec/slurper_spec.rb",
     "spec/story_spec.rb"
  ]

  s.add_bundler_dependencies
end
