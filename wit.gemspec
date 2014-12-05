Gem::Specification.new do |s|
	s.name = "wit"
	s.version = '1.0.6'
	s.date = '2014-12-05'
	s.summary = 'Ruby SDK for Wit'
	s.description = 'Ruby SDK for Wit.AI'
	s.authors = ["Julien Odent"]
	s.email = 'julien@wit.ai'
	s.homepage = 'http://wit.ai'
	s.license = 'GPL-2.0'
	s.platform = Gem::Platform::RUBY
	s.files = Dir.glob("ext/wit/**/*")
	s.extensions = %w[ext/wit/extconf.rb]
	s.required_ruby_version = '>= 1.9.3'
end
