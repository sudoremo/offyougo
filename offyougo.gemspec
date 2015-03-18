# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "offyougo"
  s.version = "0.0.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Remo Fritzsche"]
  s.date = "2015-03-18"
  s.executables = ["offyougo"]
  s.files = [".gitignore", "LICENSE", "README.md", "Rakefile", "VERSION", "bin/offyougo", "lib/offyougo.rb", "lib/offyougo/app.rb", "lib/offyougo/cli.rb", "lib/offyougo/volume_watcher.rb", "offyougo.gemspec"]
  s.require_paths = ["lib"]
  s.rubygems_version = "2.0.14"
  s.summary = "Simple command-line utility for offloading camera media using rsync."

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<bundler>, ["~> 1.3"])
      s.add_development_dependency(%q<rake>, [">= 0"])
      s.add_runtime_dependency(%q<highline>, [">= 0"])
      s.add_runtime_dependency(%q<colorize>, [">= 0"])
    else
      s.add_dependency(%q<bundler>, ["~> 1.3"])
      s.add_dependency(%q<rake>, [">= 0"])
      s.add_dependency(%q<highline>, [">= 0"])
      s.add_dependency(%q<colorize>, [">= 0"])
    end
  else
    s.add_dependency(%q<bundler>, ["~> 1.3"])
    s.add_dependency(%q<rake>, [">= 0"])
    s.add_dependency(%q<highline>, [">= 0"])
    s.add_dependency(%q<colorize>, [">= 0"])
  end
end