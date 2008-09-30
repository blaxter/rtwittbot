module Kernel
    private

    def this_method
        caller[0] =~ /`([^']*)'/ and $1
    end

    def previous_method
        caller[1] =~ /`([^']*)'/ and $1
    end
end
