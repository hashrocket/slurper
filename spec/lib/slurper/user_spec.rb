require 'spec_helper'

describe Slurper::User do

  describe '.collection' do
    before do
      Slurper::Client.stub(
        users: [
          { "person" => { "id" => 100, "name" => "Emperor Palpatine" } },
          { "person" => { "id" => 101, "name" => "Darth Vader" } }
        ]
      )
    end

    it 'turns the json response into User objects' do
      user1 = described_class.collection.first
      expect(user1.id).to eq 100
      expect(user1.name).to eq 'Emperor Palpatine'

      user2 = described_class.collection.last
      expect(user2.id).to eq 101
      expect(user2.name).to eq 'Darth Vader'
    end
  end

  describe '.find_by_name' do
    let(:user) { described_class.new(name: 'Awesome Guy', id: 9) }
    before do
      Slurper::User.stub(collection: [user, described_class.new(name: 'Super Girl', id: 7)])
    end
    subject { described_class.find_by_name(name) }

    context 'with a found user' do
      let(:name) { 'Awesome Guy' }
      it { should == user }
    end
    context 'no user found' do
      let(:name) { 'Nu Exista' }
      it { should be_nil }
    end
  end
end
