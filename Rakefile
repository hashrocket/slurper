require 'rubygems'
require 'rake'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "slurper"
    gem.summary = %Q{takes a formatted story file and puts it on Pivotal Tracker}
    gem.description = %Q{
      Slurps stories from the given file (stories.slurper by default) and creates
      Pivotal Tracker stories from them. Useful during story carding sessions
      when you want to capture a number of stories quickly without clicking
      your way through the Tracker UI.
    }
    gem.email = "info@hashrocket.com"
    gem.homepage = "http://github.com/hashrocket/slurper"
    gem.authors = ["Wes Gibbs", "Adam Lowe", "Stephen Caudill", "Tim Pope"]
    gem.add_development_dependency("rspec", ">= 1.2.9")
    gem.files = FileList["{bin,lib}/**/*"]
    gem.add_dependency("activeresource", ">= 2.3.5")
    # gem is a Gem::Specification... see http://www.rubygems.org/read/chapter/20 for additional settings
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: gem install jeweler"
end

require 'spec/rake/spectask'
Spec::Rake::SpecTask.new(:spec) do |spec|
  spec.libs << 'lib' << 'spec'
  spec.spec_files = FileList['spec/**/*_spec.rb']
end

Spec::Rake::SpecTask.new(:rcov) do |spec|
  spec.libs << 'lib' << 'spec'
  spec.pattern = 'spec/**/*_spec.rb'
  spec.rcov = true
end

task :spec => :check_dependencies

task :default => :spec

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "test #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
