require "spec_helper"
require "tmpdir"

RSpec.describe "Makeself installer" do
  it "prepares makeself package folder" do
    Dir.mktmpdir do |tmp|
      pkg_dir = File.join(tmp, "makeself-package")
      Dir.mkdir(pkg_dir)
      gem_file = File.join(tmp, "dockermancer-0.1.0.gem")
      File.write(gem_file, "dummy gem")
      installer = File.join(tmp, "installer.sh")
      File.write(installer, "#!/bin/bash\necho Hello")
      expect { system("makeself #{pkg_dir} dummy.run 'Dummy' ./installer.sh") rescue nil }.not_to raise_error
    end
  end
end

