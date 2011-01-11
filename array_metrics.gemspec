# coding: UTF-8

Gem::Specification.new do |s|
  s.name          = "array_metrics"
  s.version       = "0.0.1"
  s.platform      = Gem::Platform::RUBY
  s.authors       = ["Ricardo Panaggio"]
  s.email         = ["panaggio.ricardo@gmail.com"]
  s.homepage      = "http://github.com/panaggio/array_metrics"
  s.summary       = "A bundle of metrics for Arrays"
  s.description   = "A bundle (not that much by now) of metrics for Arrays"
  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files spec`.split("\n")
  s.has_rdoc      = true
  s.require_path  = 'lib'
  s.add_runtime_dependency "rspec", "~> 2.0"
end