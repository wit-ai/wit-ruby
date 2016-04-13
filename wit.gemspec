Gem::Specification.new do |s|
  s.name = 'wit'
  s.version = '3.0.0'
  s.date = '2014-12-05'
  s.summary = 'Ruby SDK for Wit.ai'
  s.description = 'Ruby SDK for Wit.ai'
  s.authors = ['The Wit Team']
  s.email = 'help@wit.ai'
  s.homepage = 'https://wit.ai'
  s.license = 'GPL-2.0'
  s.platform = Gem::Platform::RUBY
  s.required_ruby_version = '>= 1.9.3'
  s.require_paths = ['lib']
  s.files = `git ls-files`.split("\n")
end
