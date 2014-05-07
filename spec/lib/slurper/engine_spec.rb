require 'spec_helper'

describe Slurper::Engine do
  subject { engine.stories.first }
  let(:engine) { described_class.new(File.join(File.dirname(__FILE__), "..", "..", "fixtures", filename)) }

  context "deals with leading/trailing whitespace" do
    let(:filename) { 'whitespacey_story.slurper' }
    its(:name) { should == 'Profit' }
    its(:description) { should == "In order to do something\nAs a role\nI want to click a thingy" }
    its(:story_type) { should be_nil }
    its(:labels) { should == [] }
    its(:estimate) { should be_nil }
    its(:requested_by) { should == 'Johnny Hashrocket' }
  end

  context "given values for all attributes" do
    let(:filename) { 'full_story.slurper' }
    its(:name) { should == 'Profit' }
    its(:description) { should == "In order to do something\nAs a role\nI want to click a thingy\n\nAcceptance:\n- do the thing\n- don't forget the other thing" }
    its(:story_type) { should == 'feature' }
    its(:labels) { should == [{name:'money'},{name:'power'},{name:'fame'}] }
    its(:estimate) { should be_nil }
    its(:requested_by) { should == 'Johnny Hashrocket' }
  end

  context "given only a name" do
    let(:filename) { 'name_only.slurper' }
    its(:name) { should == 'Profit' }
    its(:description) { should be_blank }
    its(:story_type) { should be_nil }
    its(:labels) { should == [] }
    its(:estimate) { should be_nil }
    its(:requested_by) { should == 'Johnny Hashrocket' }
  end

  context "given empty attributes" do
    let(:filename) { 'empty_attributes.slurper' }
    its(:name) { should be_blank }
    its(:description) { should be_blank }
    its(:story_type) { should be_nil }
    its(:labels) { should == [] }
    its(:estimate) { should be_nil }
    its(:requested_by) { should == 'Johnny Hashrocket' }
  end

  context "given advanced attributes" do
    let(:filename) { 'advanced_stories.slurper' }
    its(:name) { should == "Make the cart accept coupons on checkout" }
    its(:description) { should == "When I get to the checkout phase, I want the ability to add an optional coupon code. Use TESTCOUPON to test with." }
    its(:story_type) { should == 'feature' }
    its(:labels) { should == [{name:'cart'},{name:'coupon system'},{name:'checkout'}] }
    its(:estimate) { should == 3 }
    its(:requested_by) { should == 'Joe Developer' }
  end

  context "given a story with an array of labels" do
    let(:filename) { 'array_of_labels.slurper' }
    its(:labels) { should == [{name:'verse'},{name:'chorus'},{name:'hook'}] }
  end
end
