require "spec_helper"
require "tmpdir"

RSpec.describe "Integration tests using temp directories" do
  it "creates temporary backup directory" do
    Dir.mktmpdir do |tmp|
      backup_file = File.join(tmp, "stack_backup.tar.gz")
      File.write(backup_file, "dummy content")
      expect(File.exist?(backup_file)).to be true
      expect(File.size(backup_file)).to be > 0
    end
  end
end

