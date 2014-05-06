module Slurper
  class User
    attr_accessor :attributes
    def initialize(attrs={})
      self.attributes = (attrs || {}).symbolize_keys
    end

    def self.collection
      @collection ||= Slurper::Client.users.map do |attrs|
        Slurper::User.new(attrs['person'])
      end
    end

    def self.find_by_name(name)
      collection.detect { |user| user.name == name }
    end

    def name; attributes[:name] end
    def id;   attributes[:id]   end
  end
end
