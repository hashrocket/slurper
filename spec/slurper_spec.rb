require 'rubygems'
require 'spec'
require 'slurper'

describe Slurper do

  context "deals with leading/trailing whitespace" do
    before do
      slurper = Slurper.new(File.join(File.dirname(__FILE__), "fixtures", "whitespacey_story.slurper"))
      slurper.load_stories
      @story = slurper.stories.first
    end

    it "strips whitespace from the name" do
      @story.name.should == "Profit"
    end
  end

  context "given values for all attributes" do
    before do
      slurper = Slurper.new(File.join(File.dirname(__FILE__), "fixtures", "full_story.slurper"))
      slurper.load_stories
      @story = slurper.stories.first
    end

    it "parses the name correctly" do
      @story.name.should == "Profit"
    end

    it "parses the label correctly" do
      @story.labels.should == "money,power,fame"
    end

    it "parses the story type correctly" do
      @story.story_type.should == "feature"
    end
  end

  context "given only a name" do
    before do
      slurper = Slurper.new(File.join(File.dirname(__FILE__), "fixtures", "name_only.slurper"))
      slurper.load_stories
      @story = slurper.stories.first
    end

    it "should parse the name correctly" do
      @story.name.should == "Profit"
    end

  end

  context "given empty attributes" do
    before do
      slurper = Slurper.new(File.join(File.dirname(__FILE__), "fixtures", "empty_attributes.slurper"))
      slurper.load_stories
      @story = slurper.stories.first
    end

    it "should not set any name" do
      @story.name.should be_nil
    end

    it "should not set any labels" do
      @story.labels.should be_nil
    end
  end

end
