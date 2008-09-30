# $Id$

# Equivalent to a header guard in C/C++
# Used to prevent the class/module from being loaded more than once
unless defined? RTwittBot

module RTwittBot

    # :stopdoc:
    VERSION = '0.1'
    LIBPATH = ::File.expand_path(::File.dirname(__FILE__)) + ::File::SEPARATOR
    PATH = ::File.dirname(LIBPATH) + ::File::SEPARATOR
    # :startdoc:

    # Returns the version string for the library.
    #
    def self.version
        VERSION
    end

    # Returns the library path for the module. If any arguments are given,
    # they will be joined to the end of the libray path using
    # <tt>File.join</tt>.
    #
    def self.libpath( *args )
        args.empty? ? LIBPATH : ::File.join(LIBPATH, *args)
    end

    # Returns the lpath for the module. If any arguments are given,
    # they will be joined to the end of the path using
    # <tt>File.join</tt>.
    #
    def self.path( *args )
        args.empty? ? PATH : ::File.join(PATH, *args)
    end

    # Utility method used to rquire all files ending in .rb that lie in the
    # directory below this file that has the same name as the filename passed
    # in. Optionally, a specific _directory_ name can be passed in such that
    # the _filename_ does not have to be equivalent to the directory.
    #
    def self.require_all_libs_relative_to( fname, dir = nil )
        require 'rubygems'
        dir ||= ::File.basename(fname, '.*')
        search_me = ::File.expand_path(
            ::File.join(::File.dirname(fname), dir, '**', '*.rb'))

        rbs           = Dir.glob(search_me).sort
        previous_size = rbs.size
        while rbs.size > 0 do
            loaded = rbs.select do |rb|
                begin
                    require rb
                    true
                rescue
                    false
                end
            end
            rbs = rbs - loaded
            raise 'Unable to load libraries' if rbs.size == previous_size
            previous_size = rbs.size
        end
    end

end  # module RTwittBot

RTwittBot.require_all_libs_relative_to __FILE__

end  # unless defined?

# EOF
