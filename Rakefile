gemspec = Gem::Specification.load("dockermancer.gemspec")

# ---------------------------------------------------------
# Optional PackageTask — only load if available
# ---------------------------------------------------------
begin
  require "rake/package_task"

  Rake::PackageTask.new(gemspec.name, gemspec.version.to_s) do |p|
    p.package_files.include("**/*")
  end

rescue LoadError
  warn "[!] rake/package_task not available — skipping package task."
  # No harm done: gem still builds via `rake build`
end

# ---------------------------------------------------------
# init
# ---------------------------------------------------------
desc "Run environment initialiser, ensures makeself, etc present"
task :init do
  sh "bash bin/init.sh"
end

task default: :init


# ---------------------------------------------------------
# gem build
# ---------------------------------------------------------
desc "Build a 'dockermancer' gem"
task :build do
  sh "gem build dockermancer.gemspec"
end

# ---------------------------------------------------------
# makeself builder
# ---------------------------------------------------------
desc "Create makeself .run installer (requires makeself to be installed)"
task :makeself => :build do
  pkg_dir = "makeself-package"
  rm_rf pkg_dir
  mkdir_p pkg_dir

  cp_r Dir["dockermancer-*.gem"], pkg_dir
  cp "installer/installer.sh", pkg_dir

  sh "makeself #{pkg_dir} Dockermancer.run 'Dockermancer Installer' ./installer.sh"
end

require "rspec/core/rake_task"

desc "Run all specs"
RSpec::Core::RakeTask.new(:spec)

task test: :spec



