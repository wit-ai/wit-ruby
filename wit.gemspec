Gem::Specification.new do |s|
	s.name = "wit"
	s.version = '1.0.5'
	s.date = '2014-10-03'
	s.summary = 'Ruby SDK for Wit'
	s.description = 'Ruby SDK for Wit.AI'
	s.authors = ["Julien Odent"]
	s.email = 'julien@wit.ai'
	s.homepage = 'http://wit.ai'
	s.license = 'EPL-1.0'
	s.platform = Gem::Platform::RUBY
	s.files = Dir.glob("ext/wit/**/*")
	s.extensions = %w[ext/wit/extconf.rb]
	s.required_ruby_version = '>= 2.0.0'
end
