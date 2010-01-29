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

  def parse(story_lines)
    @story_lines = story_lines
    parse_type
    parse_name
    parse_description
    parse_labels
    self
  end

  private

  def parse_type
    @story_lines.each_with_index do |line, i|
      if start_of_value?(line, 'type')
        if starts_with_whitespace?(@story_lines[i+1])
          @attributes["story_type"] = @story_lines[i+1].strip
        else
          @attributes.delete("story_type")
        end
      end
    end
  end

  def parse_name
    @story_lines.each_with_index do |line, i|
      if start_of_value?(line, 'name')
        if starts_with_whitespace?(@story_lines[i+1])
          @attributes["name"] = @story_lines[i+1].strip
        else
          @attributes.delete("name")
        end
      end
    end
  end

  def parse_description
    @story_lines.each_with_index do |line, i|
      if start_of_value?(line, 'description')
        desc = Array.new
        while((next_line = @story_lines[i+=1]) && starts_with_whitespace?(next_line)) do
          desc << next_line
        end
        desc.empty? ? @attributes.delete("description") : @attributes["description"] = desc.join.gsub(/^ +/, "").gsub(/^\t+/, "")
      end
    end
  end

  def parse_labels
    @story_lines.each_with_index do |line, i|
      if start_of_value?(line, 'labels')
        if starts_with_whitespace?(@story_lines[i+1])
          @attributes["labels"] = @story_lines[i+1].strip
        else
          @attributes.delete("labels")
        end
      end
    end
  end

  def starts_with_whitespace?(line)
    line && line[0,1] =~ /\s/
  end

  def start_of_value?(line, attribute)
    line[0,attribute.size] == attribute
  end

end
