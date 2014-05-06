require 'active_support'
require 'active_support/core_ext/object'
require 'yaml'

module Slurper

  autoload :Client, 'slurper/client'
  autoload :Config, 'slurper/config'
  autoload :Engine, 'slurper/engine'
  autoload :Story,  'slurper/story'
  autoload :User,   'slurper/user'

  def self.slurp(story_file, reverse)
    slurper = Engine.new(story_file)
    slurper.stories.reverse! unless reverse
    slurper.process
  end
end
