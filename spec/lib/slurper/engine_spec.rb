require 'spec_helper'

describe Slurper::Engine do
  subject { engine.stories.first }
  let(:engine) { described_class.new(File.join(File.dirname(__FILE__), "..", "..", "fixtures", filename)) }

  context "deals with leading/trailing whitespace" do
    let(:filename) { 'whitespacey_story.slurper' }
    it{ expect(subject.name).to eq('Profit') }
    it{ expect(subject.description).to eq("In order to do something\nAs a role\nI want to click a thingy") }
    it{ expect(subject.story_type).to be_nil }
    it{ expect(subject.labels).to eq [] }
    it{ expect(subject.estimate).to be_nil }
    it{ expect(subject.requested_by).to eq 'Johnny Hashrocket' }
  end

  context "given values for all attributes" do
    let(:filename) { 'full_story.slurper' }
    it { expect(subject.name).to eq 'Profit' }
    it { expect(subject.description).to eq "In order to do something\nAs a role\nI want to click a thingy\n\nAcceptance:\n- do the thing\n- don't forget the other thing" }
    it { expect(subject.story_type).to eq 'feature' }
    it { expect(subject.labels).to eq [{name:'money'},{name:'power'},{name:'fame'}] }
    it { expect(subject.estimate).to be_nil }
    it { expect(subject.requested_by).to eq 'Johnny Hashrocket' }
  end

  context "given only a name" do
    let(:filename) { 'name_only.slurper' }
    it { expect(subject.name).to eq 'Profit' }
    it { expect(subject.description).to be_blank }
    it { expect(subject.story_type).to be_nil }
    it { expect(subject.labels).to eq [] }
    it { expect(subject.estimate).to be_nil }
    it { expect(subject.requested_by).to eq 'Johnny Hashrocket' }
  end

  context "given empty attributes" do
    let(:filename) { 'empty_attributes.slurper' }
    it { expect(subject.name).to be_blank }
    it { expect(subject.description).to be_blank }
    it { expect(subject.story_type).to be_nil }
    it { expect(subject.labels).to eq [] }
    it { expect(subject.estimate).to be_nil }
    it { expect(subject.requested_by).to eq 'Johnny Hashrocket' }
  end

  context "given advanced attributes" do
    let(:filename) { 'advanced_stories.slurper' }
    it { expect(subject.name).to eq "Make the cart accept coupons on checkout" }
    it { expect(subject.description).to eq "When I get to the checkout phase, I want the ability to add an optional coupon code. Use TESTCOUPON to test with." }
    it { expect(subject.story_type).to eq 'feature' }
    it { expect(subject.labels).to eq [{name:'cart'},{name:'coupon system'},{name:'checkout'}] }
    it { expect(subject.estimate).to eq 3 }
    it { expect(subject.requested_by).to eq 'Joe Developer' }
  end
end
