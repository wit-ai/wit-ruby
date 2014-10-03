require "mkmf"

PATH = File.expand_path(File.dirname(__FILE__))

LIBDIR = RbConfig::CONFIG['libdir']
INCLUDEDIR = RbConfig::CONFIG['includedir']
HEADER_DIRS = [
	PATH + '/libwit/include',
	INCLUDEDIR
]
LIB_DIRS = [
	PATH + '/libwit/lib',
	LIBDIR
]

if RUBY_PLATFORM.include? 'arm'
	system('curl -o libwit.a https://raw.githubusercontent.com/wit-ai/libwit-ruby/master/ext/wit/libwit/lib/libwit-armv6.a', :chdir=> PATH + '/libwit/lib')
elsif RUBY_PLATFORM.include? '64'
	if RUBY_PLATFORM.include? 'darwin'
		system('curl -o libwit.a https://raw.githubusercontent.com/wit-ai/libwit-ruby/master/ext/wit/libwit/lib/libwit-64-darwin.a', :chdir=> PATH + '/libwit/lib')
	else
		system('curl -o libwit.a https://raw.githubusercontent.com/wit-ai/libwit-ruby/master/ext/wit/libwit/lib/libwit-64-linux.a', :chdir=> PATH + '/libwit/lib')
	end
else
	system('curl -o libwit.a https://raw.githubusercontent.com/wit-ai/libwit-ruby/master/ext/wit/libwit/lib/libwit-32-linux.a', :chdir=> PATH + '/libwit/lib')
end

$LOCAL_LIBS = '-lwit -lsox -lcurl'

dir_config 'wit', HEADER_DIRS, LIB_DIRS

abort "missing sox" unless have_library "sox"
abort "missing curl" unless have_library "curl"
abort "missing wit.h" unless have_header "wit.h"
abort "missing libwit" unless have_library "wit"

create_makefile "wit"
