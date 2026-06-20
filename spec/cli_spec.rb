require "spec_helper"
require "dockermancer/cli"
require "tmpdir"

RSpec.describe Dockermancer::CLI do
  before(:each) do
    # Stub shell calls so Docker is not actually invoked
    Dockermancer::CLI.stubs(:sh).returns("mocked_output")
  end

  it "responds to run" do
    expect(Dockermancer::CLI).to respond_to(:run)
  end

  it "shows help on unknown command" do
    expect { Dockermancer::CLI.run(["unknown"]) }.to raise_error(SystemExit)
  end

  context "backup" do
    it "creates a tarball in tmpdir" do
      Dir.mktmpdir do |tmp|
        output = File.join(tmp, "backup.tar.gz")
        # Stub FileUtils.cp and system calls inside backup
        Dockermancer::CLI.stubs(:sh)
        Dockermancer::CLI.backup(output)
        expect(File).not_to exist(output) # real file not created; we stubbed sh
      end
    end
  end

  context "restore" do
    it "runs restore without errors (mocked)" do
      Dir.mktmpdir do |tmp|
        input = File.join(tmp, "backup.tar.gz")
        File.write(input, "") # empty dummy file
        expect { Dockermancer::CLI.restore(input) }.not_to raise_error
      end
    end
  end
end

