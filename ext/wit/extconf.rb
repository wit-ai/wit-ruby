require "mkmf"
require 'open-uri'
require 'fileutils'

PATH = File.expand_path(File.dirname(__FILE__))

LIBDIR = RbConfig::CONFIG['libdir']
INCLUDEDIR = RbConfig::CONFIG['includedir']
HEADER_DIRS = [
	"#{PATH}/libwit/include",
	INCLUDEDIR
]
LIB_DIRS = [
	"#{PATH}/libwit/lib",
	LIBDIR
]

if RUBY_PLATFORM.include? 'arm'
	LIBWIT_FILE = 'libwit-armv6.a'
elsif RUBY_PLATFORM.include? '64'
	if RUBY_PLATFORM.include? 'darwin'
		LIBWIT_FILE = 'libwit-64-darwin.a'
	else
		LIBWIT_FILE = 'libwit-64-linux.a'
	end
else
	LIBWIT_FILE = 'libwit-32-linux.a'
end
LIBWIT_PATH = "#{PATH}/libwit/lib/libwit.a"

if !File.file?(LIBWIT_PATH)
	puts "Fetching libwit..."
	dir = File.dirname(LIBWIT_PATH)
	unless File.directory?(dir)
		FileUtils.mkdir_p(dir)
	end
	open(LIBWIT_PATH, 'wb') do |file|
		total = nil
		file << open("https://github.com/wit-ai/libwit/releases/download/1.1.2/#{LIBWIT_FILE}",
		  :content_length_proc => lambda {|t|
		  	total = t
		  	print "0/#{total} bytes downloaded"
		  	STDOUT.flush
		  },
		  :progress_proc => lambda {|s|
		  	print "\r#{s}/#{total} bytes downloaded"
		  	STDOUT.flush
		  }).read
	end
	STDOUT.print(" done\n")
end

if RUBY_PLATFORM.include? 'darwin'
	libs = ['wit', 'ssl', 'crypto', 'z', 'sox', 'System', 'pthread', 'c', 'm']
else
	libs = ['wit', 'rt', 'sox', 'ssl', 'crypto', 'dl', 'pthread', 'rt', 'gcc_s', 'pthread', 'c', 'm']
end

$LOCAL_LIBS = '-l' + libs.join(' -l')

dir_config 'wit', HEADER_DIRS, LIB_DIRS

for lib in libs
	abort "Error: missing #{lib}" unless have_library lib
end
abort 'Error: missing wit.h' unless have_header 'wit.h'

create_makefile 'wit'
