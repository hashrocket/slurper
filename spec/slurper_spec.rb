require 'spec_helper'

describe Slurper do

  context "deals with leading/trailing whitespace" do
    before do
      slurper = Slurper::Main.new(File.join(File.dirname(__FILE__), "fixtures", "whitespacey_story.slurper"))
      @story = slurper.stories.first
    end

    it "strips whitespace from the name" do
      @story.name.should == "Profit"
    end
  end

  context "given values for all attributes" do
    before do
      slurper = Slurper::Main.new(File.join(File.dirname(__FILE__), "fixtures", "full_story.slurper"))
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
      slurper = Slurper::Main.new(File.join(File.dirname(__FILE__), "fixtures", "name_only.slurper"))
      @story = slurper.stories.first
    end

    it "should parse the name correctly" do
      @story.name.should == "Profit"
    end

  end

  context "given empty attributes" do
    before do
      slurper = Slurper::Main.new(File.join(File.dirname(__FILE__), "fixtures", "empty_attributes.slurper"))
      @story = slurper.stories.first
    end

    it "should not set any name" do
      @story.name.should be_nil
    end

    it "should not set any labels" do
      @story.labels.should be_nil
    end
  end

  context "given advanced attributes" do
    before do
      slurper = Slurper::Main.new(File.join(File.dirname(__FILE__), "fixtures", "advanced_stories.slurper"))
      @story = slurper.stories.first
    end

    it "should have an estimate" do
      @story.estimate.should == 3
    end

    it "should have an owner" do
      @story.owned_by.should == 'Joe Developer'
    end
  end
end
