require 'yaml'
require 'story'
YAML::ENGINE.yamler='syck' if RUBY_VERSION > '1.9'


class Slurper

  attr_accessor :story_file, :stories

  def self.slurp(story_file, reverse)
    slurper = new(story_file)
    slurper.load_stories
    slurper.prepare_stories
    slurper.stories.reverse! unless reverse
    slurper.create_stories
  end

  def initialize(story_file)
    self.story_file = story_file
  end

  def load_stories
    self.stories = YAML.load(yamlize_story_file)
  end

  def prepare_stories
    stories.each { |story| story.prepare }
  end

  def create_stories
    puts "Preparing to slurp #{stories.size} stories into Tracker..."
    stories.each_with_index do |story, index|
      begin
        if story.save
          puts "#{index+1}. #{story.name}"
        else
          puts "Slurp failed. #{story.errors.full_messages}"
        end
      rescue ActiveResource::ConnectionError => e
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

  def yamlize_story_file
    IO.read(story_file).
      gsub(/^/, "    ").
      gsub(/    ==.*/, "- !ruby/object:Story\n  attributes:").
      gsub(/    description:$/, "    description: |")
  end

end
