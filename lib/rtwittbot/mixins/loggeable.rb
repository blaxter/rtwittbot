module Loggeable
    def log_error(e)
        puts "#{Time.now} ERROR in #{previous_method}: #{e}"
    end
end

