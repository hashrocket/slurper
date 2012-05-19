require 'rubygems'
require 'spec'
require 'slurper'

describe Story do

  it "uses http by default" do
    Story.site.scheme.should == "http"
    Story.yaml['ssl'].should be_nil
  end

  it "uses https if set in the config" do
    Story.stub(:yaml => {"ssl" => true})
    Story.config['ssl'].should be_true
    Story.site.scheme.should == "https"
    Story.ssl_options[:verify_mode].should == 1

    # Not sure what this next line is testing
    File.open(File.expand_path('lib/cacert.pem')).readlines.find_all{ |l| l.starts_with?("Equifax") }.count.should == 4
  end

  context "#prepare" do
    it "scrubs the description" do
      story = Story.new
      story.stub!(:default_requested_by)
      story.should_receive(:scrub_description)
      story.prepare
    end

    it "scrubs the defaults the requested_by attribute" do
      story = Story.new
      story.stub!(:scrub_description)
      story.should_receive(:default_requested_by)
      story.prepare
    end
  end

  context "#to_xml" do
    it "excludes the tasks attribute" do
      story = Story.new(
        :story_type => "feature",
        :name => "Profit",
        :tasks => ["build something epic", "charge a lot for it"])
      story.to_xml.should == "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<story>\n  <story-type>feature</story-type>\n  <name>Profit</name>\n</story>\n"
    end
  end

  context "#extract_tasks" do
    it "returns an empty array for a story with no tasks" do
      story = Story.new
      story.extract_tasks.should == []
    end

    it "returns an array of Tasks with the appropriate descriptions for a story with tasks" do
      story = Story.new(:tasks => ["build something epic"])
      task = story.extract_tasks[0]
      task.should be_an_instance_of(Task)
      task.description.should == "build something epic"
    end
  end

  context "requested_by attribute" do
    it "uses the default if not given one" do
      Story.stub!(:config).and_return({"requested_by" => "Mr. Client"})
      story = Story.new
      story.send(:default_requested_by)
      story.requested_by.should == "Mr. Client"
    end

    it "uses the default if given a blank requested_by" do
      Story.stub!(:config).and_return({"requested_by" => "Mr. Client"})
      story = Story.new(:requested_by => "")
      story.send(:default_requested_by)
      story.requested_by.should == "Mr. Client"
    end

    it "uses the name given in the story file if there is one" do
      Story.stub!(:config).and_return({"requested_by" => "Mr. Client"})
      story = Story.new(:requested_by => "Mr. Stakeholder")
      story.send(:default_requested_by)
      story.requested_by.should == "Mr. Stakeholder"
    end
  end

  context "scrubs the descriptions correctly" do
    it "when the description is blank" do
      story = Story.new(:description => "")
      story.send(:scrub_description)
      story.description.should be_nil
    end

    it "when there is no description given" do
      story = Story.new
      lambda {
        story.send(:scrub_description)
      }.should_not raise_error
    end

    it "when it contains quotes" do
      desc = <<-STRING
        I have a "quote"
      STRING
      story = Story.new(:description => desc)
      story.send(:scrub_description)
      story.description.should == "I have a \"quote\"\n"
    end

    it "when it is full of whitespace" do
      desc = <<-STRING
        In order to do something   
        As a role     
        I want to click a thingy  
      STRING
      story = Story.new(:description => desc)
      story.send(:scrub_description)
      story.description.should == "In order to do something\nAs a role\nI want to click a thingy\n"
    end

    it "when it contains acceptance criteria" do
      desc = <<-STRING
        In order to do something
        As a role
        I want to click a thingy

        Acceptance:
        - do the thing
        - don't forget the other thing
      STRING
      story = Story.new(:description => desc)
      story.send(:scrub_description)
      story.description.should == "In order to do something\nAs a role\nI want to click a thingy\n\nAcceptance:\n- do the thing\n- don't forget the other thing\n"
    end
  end

end
