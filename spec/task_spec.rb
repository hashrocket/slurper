require 'rubygems'
require 'spec'
require 'slurper'

describe Task do

  it "uses http by default" do
    Task.site.scheme.should == "http"
    Task.yaml['ssl'].should be_nil
  end

  it "uses https if set in the config" do
    Task.stub(:yaml => {"ssl" => true})
    Task.config['ssl'].should be_true
    Task.site.scheme.should == "https"
    Task.ssl_options[:verify_mode].should == 1

    # Not sure what this next line is testing
    File.open(File.expand_path('lib/cacert.pem')).readlines.find_all{ |l| l.starts_with?("Equifax") }.count.should == 4
  end

  context "#prepare" do
    it "scrubs the description" do
      task = Task.new
      task.stub!(:default_requested_by)
      task.should_receive(:scrub_description)
      task.prepare
    end
  end

  context "scrubs the descriptions correctly" do
    it "when the description is blank" do
      task = Task.new(:description => "")
      task.send(:scrub_description)
      task.description.should be_nil
    end

    it "when there is no description given" do
      task = Task.new
      lambda {
        task.send(:scrub_description)
      }.should_not raise_error
    end

    it "when it contains quotes" do
      desc = <<-STRING
        I have a "quote"
      STRING
      task = Task.new(:description => desc)
      task.send(:scrub_description)
      task.description.should == "I have a \"quote\"\n"
    end

    it "when it is full of whitespace" do
      desc = "  Do this task  "
      task = Task.new(:description => desc)
      task.send(:scrub_description)
      task.description.should == "Do this task"
    end
  end

end
