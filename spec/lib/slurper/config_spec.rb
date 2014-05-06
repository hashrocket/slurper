require 'spec_helper'

describe Slurper::Config do
  subject { Slurper::Config }
  its(:project_id) { should == 12345 }
  its(:requested_by) { should == 'Johnny Hashrocket' }
  its(:token) { should == '123abc123abc123abc123abc' }
end
