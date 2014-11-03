require File.expand_path('../lib/unicorn-reloader/version', __FILE__)

Gem::Specification.new do |gem|
  gem.name        = 'unicorn-reloader'
  gem.version     = Unicorn::Reloader::VERSION
  gem.date        = Time.now.strftime('%F')
  gem.summary     = "A watcher to automatically reload unicorn when files change"
  gem.description = "A watcher to automatically reload unicorn when files change"
  gem.authors     = ['Adam Gotterer']
  gem.email       = 'agotterer+gem@gmail.com'
  gem.files       = Dir.glob(["{lib}/**/*", "{bin}/**/*"]) + %w(LICENSE README.md)
  gem.executables = ['unicorn-reloader']
  gem.test_files  = Dir.glob("{spec}/**/*")
  gem.require_paths = ['lib']
  gem.homepage    = 'https://github.com/adamgotterer/unicorn-reloader'

  gem.required_ruby_version = '>= 1.9.2'
  gem.add_dependency('unicorn', '>= 4.8')
  gem.add_dependency('listen', '~> 2.7')
end
