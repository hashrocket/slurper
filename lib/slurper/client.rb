require 'typhoeus'

module Slurper
  class Client
    CREATE_STORY_URL = "https://www.pivotaltracker.com/services/v5/projects/#{Slurper::Config.project_id}/stories"
    USERS_URL        = "https://www.pivotaltracker.com/services/v5/projects/#{Slurper::Config.project_id}/memberships"

    def self.create(story)
      Typhoeus.post CREATE_STORY_URL,
        body: story.to_json,
        headers: {
          "Content-Type" => "application/json",
          "X-TrackerToken" => Slurper::Config.token
        }
    end

    def self.users
      JSON.parse(Typhoeus.get(
        USERS_URL,
        headers: { "X-TrackerToken" => Slurper::Config.token }
      ).try(:body) || '[]')
    end
  end
end
