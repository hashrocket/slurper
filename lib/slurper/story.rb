require 'json'

module Slurper
  class Story

    attr_accessor :attributes
    def initialize(attrs={})
      self.attributes = (attrs || {}).symbolize_keys

      if attributes[:owned_by].present?
        puts "DEPRECATION WARNING: `owned_by` is no longer a supported attribute. Please change to `requested_by`."
        attributes[:requested_by] = attributes[:owned_by]
      end
    end

    def to_json
      {
        name: name,
        description: description,
        story_type: story_type,
        labels: labels,
        estimate: estimate,
        requested_by_id: requested_by_id
      }.reject { |k,v| v.blank? }.to_json
    end

    def save
      (@response = Slurper::Client.create(self)).success?
    end

    def error_message; @response.body end

    def name;       attributes[:name]       end
    def estimate;   attributes[:estimate]   end
    def story_type; attributes[:story_type] end

    def description
      return nil unless attributes[:description].present?
      attributes[:description].split("\n").map(&:strip).join("\n")
    end

    def labels
      return [] unless attributes[:labels].present?

      array = if attributes[:labels].is_a? Array
                attributes[:labels]
              else
                attributes[:labels].split ','
              end

      array.map { |tag| { name: tag } }
    end

    def requested_by
      attributes[:requested_by].presence || Slurper::Config.requested_by
    end

    def requested_by_id
      Slurper::User.find_by_name(requested_by).try(:id) if requested_by.present?
    end

    def valid?
      if name.blank?
        raise "Name is blank for story:\n#{to_json}"
      elsif !requested_by_id
        raise "Could not find requester \"#{requested_by}\" in project"
      end
    end

  end
end
