
require "rake"
require "rake/package_task"

gemspec = Gem::Specification::load("dockermancer.gemspec")

Rake::PackageTask.new(gemspec.name, gemspec.version.to_s) do |p|
  p.package_files.include("**/*")
end

desc "Build gem"
task :build do
  sh "gem build dockermancer.gemspec"
end

desc "Create makeself .run installer (requires makeself to be installed)"
task :makeself => :build do
  pkg_dir = "makeself-package"
  rm_rf pkg_dir
  mkdir_p pkg_dir
  cp_r Dir["dockermancer-*.gem"], pkg_dir
  cp "installer/installer.sh", pkg_dir
  sh "makeself #{pkg_dir} Dockermancer.run 'Dockermancer Installer' ./installer.sh"
end
