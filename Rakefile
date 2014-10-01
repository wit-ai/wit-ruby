require 'rake/extensiontask'

spec = Gem::Specification.new do |s|
	s.name = "wit"
	s.version = '1.0.0'
	s.date = '2014-09-30'
	s.summary = 'Ruby SDK for Wit'
	s.description = 'Ruby SDK for Wit.AI'
	s.authors = ["Julien Odent"]
	s.email = 'julien@wit.ai'
	s.homepage = 'http://wit.ai'
	s.license = 'EPL-1.0'
	s.platform = Gem::Platform::RUBY
	s.files = Dir.glob("ext/wit/**/*")
	s.extensions = %w[ext/wit/extconf.rb]
end

Gem::PackageTask.new(spec) do |pkg|
end

Rake::ExtensionTask.new('wit', spec)
