require 'active_resource'

class Story < ActiveResource::Base

  @@defaults = YAML.load_file(File.expand_path(File.join("~", ".slurper.yml")))
  self.site = "http://www.pivotaltracker.com/services/v3/projects/#{@@defaults['project_id']}"
  headers['X-TrackerToken'] = @@defaults.delete("token")
  attr_accessor :story_lines

  def initialize(attributes = {})
    @attributes     = {}
    @prefix_options = {}
    load(@@defaults.merge(attributes))
  end

end
