require 'story'

class Slurper
  attr_accessor :story_file, :stories

  def self.slurp(story_file, reverse = true)
    slurper = new(story_file)
    slurper.yamlize_story_file
    slurper.stories.reverse! if reverse
    slurper.create_stories
  end

  def initialize(story_file)
    self.story_file = story_file
  end

  def yamlize_story_file
    self.stories = YAML.load(
      IO.read(story_file).
        gsub(/^/, "    ").
        gsub(/    ==.*/, "- !ruby/object:Story\n  attributes:").
        gsub(/    description:$/, "    description: |")
    )
    scrub_descriptions
  end

  def create_stories
    puts "Preparing to slurp #{stories.size} stories into Tracker..."
    stories.each_with_index do |story, index|
      begin
        story.save
        puts "#{index+1}. #{story.name}"
      rescue ActiveResource::ServerError, ActiveResource::ResourceNotFound => e
        msg = "Slurp failed on story "
        if story.attributes["name"]
          msg << story.attributes["name"]
        else
          msg << "##{options[:reverse] ? index + 1 : stories.size - index }"
        end
        puts msg + ".  Error: #{e}"
      end
    end
  end

  protected

  def scrub_descriptions
    stories.each do |story|
      if story.respond_to? :description
        story.description = story.description.gsub("  ", "").gsub(" \n", "\n")
      end
      if story.respond_to?(:description) && story.description == ""
        story.attributes["description"] = nil
      end
    end
  end

end
