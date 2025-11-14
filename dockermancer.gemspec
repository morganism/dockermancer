
Gem::Specification.new do |s|
  s.name        = "dockermancer"
  s.version     = "0.1.0"
  s.summary     = "Docker-compose backup/resurrection utility"
  s.description = "Extracts images, volumes, bind mounts, and compose config; recreates elsewhere."
  s.authors     = ["Morganism"]
  s.email       = ["morgan@morganism.dev"]
  s.files       = Dir.glob("**/*").reject { |f| f =~ /\.git/ }
  s.executables = ["dockermancer"]
  s.require_paths = ["lib"]
  s.homepage    = "https://github.com/morganism/dockermancer/wiki"
end
