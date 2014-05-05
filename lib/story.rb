require 'active_resource'

class Story < ActiveResource::Base

  def self.config
    scheme =  if Slurper::Config.ssl
                self.ssl_options = {  :verify_mode => OpenSSL::SSL::VERIFY_PEER,
                                      :ca_file => File.join(File.dirname(__FILE__), "cacert.pem") }
                "https"
              else
                "http"
              end
    self.site = "#{scheme}://www.pivotaltracker.com/services/v3/projects/#{Slurper::Config.project_id}"
  end


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
    if (!respond_to?(:requested_by) || requested_by == "") && Slurper::Config.requested_by
      self.attributes["requested_by"] = Slurper::Config.requested_by
    end
  end

end
