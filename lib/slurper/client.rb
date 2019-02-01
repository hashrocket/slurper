require 'rest-client'

module Slurper
  class Client
    CREATE_STORY_URL = "https://www.pivotaltracker.com/services/v5/projects/#{Slurper::Config.project_id}/stories"
    USERS_URL        = "https://www.pivotaltracker.com/services/v5/projects/#{Slurper::Config.project_id}/memberships"

    def self.create(story)
      RestClient.post(
        CREATE_STORY_URL,
        story.to_json,
        {
          "Content-Type" => "application/json",
          "X-TrackerToken" => Slurper::Config.token
        }
      )
    end

    def self.users
      JSON.parse(RestClient.get(
        USERS_URL,
        { "X-TrackerToken" => Slurper::Config.token }
      ).try(:body) || '[]')
    end
  end
end
