require 'yaml'
require 'logger'
require 'active_resource'
require 'story'
require 'task'
YAML::ENGINE.yamler='syck' if RUBY_VERSION > '1.9'


class Slurper

  attr_accessor :story_file, :stories

  def self.slurp(story_file, reverse, debug=false)
    if debug
      ActiveResource::Base.logger = Logger.new(STDOUT)
      ActiveResource::Base.logger.level = Logger::DEBUG
    else
      ActiveResource::Base.logger = nil
    end

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
        tasks = story.extract_tasks
        if story.save
          puts "#{index+1}. #{story.name}"
          tasks.each do |task|
            task.prefix_options[:story_id] = story.id
            if task.save
              puts "- #{task.description}"
            else
              puts "Slurp failed. #{task.errors.full_messages}"
            end
          end
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
