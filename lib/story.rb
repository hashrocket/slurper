class Story < ActiveResource::Base

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
    self.site = "#{scheme}://www.pivotaltracker.com/services/v3/projects/#{@@config['project_id']}"
    @@config
  end


  headers['X-TrackerToken'] = config.delete("token")

  def prepare
    scrub_description
    default_requested_by
  end

  def to_xml(options={})
    options[:except] ||= []
    options[:except] << :tasks
    super(options)
  end

  def extract_tasks
    if respond_to?(:tasks)
      tasks.collect {|task| Task.new(:description => task)}
    else
      []
    end
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
