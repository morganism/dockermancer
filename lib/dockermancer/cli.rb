
require "json"
require "fileutils"
require "tmpdir"

module Dockermancer
  class CLI
    class Error < StandardError; end

    def self.run(argv)
      cmd = argv.shift
      case cmd
      when "backup"
        abort "Usage: dockermancer backup <output.tar.gz>" unless argv[0]
        backup(argv[0])
      when "restore"
        abort "Usage: dockermancer restore <input.tar.gz>" unless argv[0]
        restore(argv[0])
      when "help", nil, "--help", "-h"
        puts "dockermancer: backup & restore docker-compose stacks"
        puts "Usage:"
        puts "  dockermancer backup <out.tar.gz>"
        puts "  dockermancer restore <in.tar.gz>"
      else
        abort "Unknown command: \#{cmd}"
      end
    end

    def self.sh(cmd)
      out = `\#{cmd} 2>&1`
      raise Error, "Command failed (\"\#{cmd}\"):\n\#{out}" unless $?.success?
      out.strip
    end

    def self.backup(output)
      Dir.mktmpdir("dcb") do |tmp|
        puts "Collecting docker-compose files..."
        FileUtils.cp("docker-compose.yml", "\#{tmp}/docker-compose.yml") if File.exist?("docker-compose.yml")
        FileUtils.cp(".env", "\#{tmp}/.env") if File.exist?(".env")

        puts "Converting compose config..."
        config = JSON.parse(sh("docker compose convert --format json")) rescue {}
        services = config["services"] || {}

        images_dir = "\#{tmp}/images"
        volumes_dir = "\#{tmp}/volumes"
        binds_dir = "\#{tmp}/binds"
        FileUtils.mkdir_p(images_dir, volumes_dir, binds_dir)

        puts "Exporting images..."
        services.each do |_svc, cfg|
          img = cfg && cfg["image"]
          next unless img && !img.empty?
          safe = img.gsub(/[\/:]/, "_")
          puts " - \#{img} -> \#{safe}.tar"
          sh("docker pull \#{img} >/dev/null 2>&1 || true")
          sh("docker save -o \#{images_dir}/\#{safe}.tar \#{img}")
        end

        puts "Exporting named volumes..."
        vols = sh("docker volume ls --format '{{.Name}}'").split("\n").reject(&:empty?)
        vols.each do |vol|
          puts " - \#{vol}"
          sh("docker run --rm -v \#{vol}:/data -v \#{volumes_dir}:/backup alpine tar czf /backup/\#{vol}.tar.gz /data")
        end

        puts "Exporting bind mounts..."
        services.each do |_svc, cfg|
          next unless cfg && cfg["volumes"]
          cfg["volumes"].each do |mount|
            host, _ = mount.split(":", 2)
            next unless host && host.start_with?("/")
            safe = host.gsub(/[\/]/, "_")
            puts " - \#{host} -> \#{safe}.tar.gz"
            sh("tar czf \#{binds_dir}/\#{safe}.tar.gz \#{host}")
          end
        end

        puts "Packaging into \#{output}..."
        sh("tar czf \#{output} -C \#{tmp} .")
        puts "Backup complete: \#{output}"
      end
    end

    def self.restore(input)
      Dir.mktmpdir("dcr") do |tmp|
        puts "Extracting \#{input}..."
        sh("tar xzf \#{input} -C \#{tmp}")

        puts "Loading images..."
        Dir[File.join(tmp, 'images', '*.tar')].each do |img|
          puts " - \#{File.basename(img)}"
          sh("docker load -i \#{img}")
        end

        puts "Restoring volumes..."
        Dir[File.join(tmp, 'volumes', '*.tar.gz')].each do |vf|
          vol = File.basename(vf).sub('.tar.gz','')
          puts " - \#{vol}"
          sh("docker volume create \#{vol}")
          sh("docker run --rm -v \#{vol}:/data -v \#{tmp}/volumes:/backup alpine sh -c \"cd /data && tar xzf /backup/\#{File.basename(vf)} --strip 1\"")
        end

        puts "Restoring bind mounts (will write to host paths)..."
        Dir[File.join(tmp, 'binds', '*.tar.gz')].each do |bf|
          puts " - \#{File.basename(bf)}"
          sh("tar xzf \#{bf} -C /")
        end

        puts "Restoring compose files..."
        FileUtils.cp(File.join(tmp, 'docker-compose.yml'), './docker-compose.yml') if File.exist?(File.join(tmp, 'docker-compose.yml'))
        FileUtils.cp(File.join(tmp, '.env'), './.env') if File.exist?(File.join(tmp, '.env'))

        puts "Bringing stack up..."
        sh("docker compose up -d")
        puts "Restore complete."
      end
    end
  end
end
