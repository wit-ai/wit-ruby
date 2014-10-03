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

if RUBY_PLATFORM.include? "arm"
	LIBWIT_FILE = "libwit-armv6.a"
elsif RUBY_PLATFORM.include? "64"
	if RUBY_PLATFORM.include? "darwin"
		LIBWIT_FILE = "libwit-64-darwin.a"
	else
		LIBWIT_FILE = "libwit-64-linux.a"
	end
else
	LIBWIT_FILE = "libwit-32-linux.a"
end
abort "unable to retrieve libwit" unless system('curl -o libwit.a https://raw.githubusercontent.com/wit-ai/libwit/master/releases/' + LIBWIT_FILE, :chdir=> PATH + '/libwit/lib')

$LOCAL_LIBS = '-lwit -lsox -lcurl'

dir_config 'wit', HEADER_DIRS, LIB_DIRS

abort "missing sox" unless have_library "sox"
abort "missing curl" unless have_library "curl"
abort "missing wit.h" unless have_header "wit.h"
abort "missing libwit" unless have_library "wit"

create_makefile "wit"
