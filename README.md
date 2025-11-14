
# Dockermancer

Dockermancer packages a docker-compose stack (images, named volumes, bind mounts, and compose files) into a single transportable archive and can restore it on another host.

## Quickstart

rake [init] is a good thing to run as it will ensure all required software is present or install it if not.

### Rake tasks

- rake           : rake init : DEFAULT

- rake init      : Run environment initialiser, ensures makeself, etc present

- rake build     : Build a 'dockermancer' gem

- rake makeself  : Create makeself .run installer (requires makeself to be installed, use 'rake [init]'§)



### Build gem
```
gem build dockermancer.gemspec
```

### Backup
```
dockermancer backup stack_backup.tar.gz
```

### Move and restore on target host
```
scp stack_backup.tar.gz target:/tmp
gem install dockermancer-0.1.0.gem
dockermancer restore /tmp/stack_backup.tar.gz
```

## GitHub Actions CI
A workflow is included that builds the gem and (optionally) the makeself .run archive as artifacts.
