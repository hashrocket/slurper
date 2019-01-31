module Slurper
  class Engine < Struct.new(:story_file)

    def stories
      @stories ||= YAML.load(yamlize_story_file).map { |attrs| Slurper::Story.new(attrs) }
    end

    def process
      puts "Validating story content"
      stories.each(&:valid?)

      puts "Preparing to slurp #{stories.size} stories into Tracker..."
      stories.each_with_index do |story, index|
        if story.save
          puts "#{index+1}. #{story.name}"
        else
          puts "Slurp failed. #{story.error_message}"
        end
      end
    end

    protected

    def yamlize_story_file
      IO.read(story_file)
        .then {|x| x.strip}
        .then {|x| x.gsub(/^ \b/, "  ") }
        .then {|x| x.gsub(/^/, "    ") }
        .then {|x| x.gsub(/ $/, "") }
        .then {|x| x.gsub(/    ==.*/, "-") }
        .then {|x| x.gsub(/    description:$/, "    description: |") }
    end
  end
end
