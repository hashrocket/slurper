require 'spec_helper'

describe Slurper::Story do

  before do
    Slurper::User.stub(
      collection: [Slurper::User.new(name: 'Johnny Hashrocket', id: 9)]
    )
  end

  describe '#to_json' do
    subject { story.to_json }

    context 'fully populated' do
      let(:story) do
        described_class.new(
          name: 'one',
          description: 'two',
          story_type: 'bug',
          labels: 'three,four',
          estimate: 5
        )
      end
      it do
        should == {
          name: 'one',
          description: 'two',
          story_type: 'bug',
          labels: [{name:'three'},{name:'four'}],
          estimate: 5,
          requested_by_id: 9
        }.to_json
      end
    end

    context 'with just a name' do
      let(:story) { described_class.new(name: 'one') }
      it { should == { name: 'one', requested_by_id: 9 }.to_json }
    end
  end

  describe "#description" do
    subject { story.description }
    let(:story) { described_class.new(description: description) }

    context "when the description is blank" do
      let(:description) { '' }
      it { should be_nil }
    end

    context "when there is no description given" do
      let(:story) { described_class.new }
      it { should be_nil }
    end

    context "when it contains quotes" do
      let(:description) do
        <<-STRING
          I have a "quote"
        STRING
      end
      it { should == "I have a \"quote\"" }
    end

    context "when it is full of whitespace" do
      let(:description) do
        <<-STRING
          In order to do something
          As a role
          I want to click a thingy
        STRING
      end
      it { should == "In order to do something\nAs a role\nI want to click a thingy" }
    end

    context "when it contains acceptance criteria" do
      let(:description) do
        <<-STRING
          In order to do something
          As a role
          I want to click a thingy

          Acceptance:
          - do the thing
          - don't forget the other thing
        STRING
      end
      it { should == "In order to do something\nAs a role\nI want to click a thingy\n\nAcceptance:\n- do the thing\n- don't forget the other thing" }
    end
  end

  describe '#labels' do
    let(:story) { described_class.new(labels: labels) }
    subject { story.labels }

    context 'when blank' do
      let(:labels) { nil }
      it { should == [] }
    end

    context 'with one' do
      let(:labels) { 'tag' }
      it { should == [{name:'tag'}] }
    end

    context 'with multiple' do
      let(:labels) { 'one,two' }
      it { should == [{name:'one'},{name:'two'}] }
    end
  end

  describe "#requested_by" do
    subject { story.requested_by }
    let(:story) { described_class.new(requested_by: requested_by) }

    context "uses the default if not provided" do
      let(:requested_by) { nil }
      it { should == 'Johnny Hashrocket' }
    end

    context "uses the default if given a blank" do
      let(:requested_by) { '' }
      it { should == 'Johnny Hashrocket' }
    end

    context "uses the name given in the story file if there is one" do
      let(:requested_by) { 'Mr. Stakeholder' }
      it { should == 'Mr. Stakeholder' }
    end
  end

  describe '#requested_by_id' do
    subject { story.requested_by_id }
    let(:story) { described_class.new(requested_by: requested_by) }

    before do
      Slurper::User.stub(collection: [Slurper::User.new(name: 'George Washington', id: 5)])
    end

    context 'with a matching user' do
      let(:requested_by) { 'George Washington' }
      it { should == 5 }
    end

    context 'without a matching user' do
      let(:requested_by) { 'Peter Pan' }
      it { should be_nil }
    end
  end
end
