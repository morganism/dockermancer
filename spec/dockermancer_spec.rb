# spec/dockermancer_spec.rb
require "spec_helper"
require "dockermancer"

RSpec.describe Dockermancer do
  it "has a version number" do
    expect(Dockermancer::VERSION).not_to be_nil
  end
end

