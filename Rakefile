task :gemspec do
  spec = Gem::Specification.new do |spec|
    spec.name          = 'offyougo'
    spec.version       = IO.read('VERSION').chomp
    spec.authors       = ['Remo Fritzsche']
    spec.summary       = 'Simple command-line utility for offloading camera media using rsync.'
    spec.files         = `git ls-files`.split($/)

    spec.executables   = ['offyougo']
    spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
    spec.require_paths = ['lib']

    spec.add_development_dependency 'bundler', '~> 1.3'
    spec.add_development_dependency 'rake'
  end

  File.open('offyougo.gemspec', 'w') { |f| f.write(spec.to_ruby.strip) }
end