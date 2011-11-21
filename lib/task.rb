class Task < ActiveResource::Base

  def self.yaml
    YAML.load_file('slurper_config.yml')
  end

  def self.config
    @@config = yaml
    scheme =  if !!@@config['ssl']
                self.ssl_options = {  :verify_mode => OpenSSL::SSL::VERIFY_PEER,
                                      :ca_file => File.join(File.dirname(__FILE__), "cacert.pem") }
                "https"
              else
                "http"
              end
    self.site = "#{scheme}://www.pivotaltracker.com/services/v3/projects/#{@@config['project_id']}/stories/:story_id"
    @@config
  end


  headers['X-TrackerToken'] = config.delete("token")

  def prepare
    scrub_description
  end

  protected

  def scrub_description
    if respond_to?(:description)
      self.description = description.gsub("  ", "")
      self.attributes["description"] = nil if description == ""
    end
  end

end
