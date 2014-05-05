module Slurper

  class Config

    def self.ssl; @ssl ||= !!yaml['ssl'] end
    def self.project_id; @project_id ||= yaml['project_id'] end
    def self.requested_by; @requested_by ||= yaml['requested_by'] end
    def self.token; @token ||= yaml['token'] end

    private

    def self.yaml
      YAML.load_file('slurper_config.yml')
    end

  end

end
