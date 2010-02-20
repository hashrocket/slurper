require 'active_resource'

class Story < ActiveResource::Base

  def self.config
    @@config ||= YAML.load_file('slurper_config.yml')
  end

  self.site = "http://www.pivotaltracker.com/services/v3/projects/#{config['project_id']}"
  headers['X-TrackerToken'] = config.delete("token")

  def prepare
    scrub_description
    default_requested_by
  end

  protected

  def scrub_description
    if respond_to?(:description)
      self.description = description.gsub("  ", "").gsub(" \n", "\n")
    end
    if respond_to?(:description) && description == ""
      self.attributes["description"] = nil
    end
  end

  def default_requested_by
    if (!respond_to?(:requested_by) || requested_by == "") && Story.config["requested_by"]
      self.attributes["requested_by"] = Story.config["requested_by"]
    end
  end

end
