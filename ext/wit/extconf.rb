require "mkmf"

PATH = File.expand_path(File.dirname(__FILE__))

if not File.exist?(PATH + '/libwit')
	p "Cloning libwit repository..."
	abort "unable to clone libwit repository" unless system("git clone https://github.com/wit-ai/libwit.git", :chdir=> PATH)
	p "Updating libwit..."
	abort "unable to update libwit repository" unless system("git pull", :chdir=> PATH + "/libwit")
end
if not (File.exist?(PATH + '/libwit/include/libwit.a') and File.exist?(PATH + '/libwit/lib/wit.h'))
	p "Compiling libwit..."
	abort "could not build libwit" unless system("./build_c.sh;", :chdir=> PATH + "/libwit")
end

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

$LOCAL_LIBS = '-lwit -lsox -lcurl'

dir_config 'wit', HEADER_DIRS, LIB_DIRS

abort "missing wit.h" unless have_header "wit.h"
abort "missing libwit" unless have_library "wit", "wit_init"

create_makefile "wit"
