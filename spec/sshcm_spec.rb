require_relative "spec_helper"

RSpec.describe SSHcm do
  it "has a version number" do
    expect(SSHcm::VERSION).not_to be nil
  end
end
