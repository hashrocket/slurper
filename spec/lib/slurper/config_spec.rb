require 'spec_helper'

describe Slurper::Config do
  subject { Slurper::Config }
  it { expect(subject.project_id).to eq 12345 }
  it { expect(subject.requested_by).to eq 'Johnny Hashrocket' }
  it { expect(subject.token).to eq '123abc123abc123abc123abc' }
end
