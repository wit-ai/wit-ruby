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
	system('ln -s libwit-armv6.a libwit.a', :chdir=> PATH + '/libwit/lib')
elsif RUBY_PLATFORM.include? '64'
	if RUBY_PLATFORM.include? 'darwin'
		system('ln -s libwit-64-darwin.a libwit.a', :chdir=> PATH + '/libwit/lib')
	else
		system('ln -s libwit-64-linux.a libwit.a', :chdir=> PATH + '/libwit/lib')
	end
else
	system('ln -s libwit-32-linux.a libwit.a', :chdir=> PATH + '/libwit/lib')
end

$LOCAL_LIBS = '-lwit -lsox -lcurl'

dir_config 'wit', HEADER_DIRS, LIB_DIRS

abort "missing wit.h" unless have_header "wit.h"
abort "missing libwit" unless have_library "wit"

create_makefile "wit"
