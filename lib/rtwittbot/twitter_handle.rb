require 'rubygems'
require 'time'
require 'twitter'

class TwitterHandle
    Max = 10

    def initialize(user, password)
        @twitter = Twitter::Client.new(:login => user, :password => password)
        @last_fetch = Time.now - 60 # 1 minute ago

        @_last_twits = []
    end
    
    def has_been_fetched?(r)
        fetched = @_last_twits.include? r
        unless fetched
            @_last_twits.delete_at 0 unless @_last_twits.size < TwitterHandle::Max
            @_last_twits << r.id
        else
            puts "Status has been fetched twice! #{r.text}, #{r.created_at}, #{r.id}"
        end
        fetched
    end

    def twit(message)
        @twitter.status :post, message
    end

    #
    # [] Ordered datetime array with
    #  `* 
    #   |- :author  - String
    #   |- :nick    - String
    #   |- :message - String
    #   `- :time    - Time
    def timeline(since = @last_fetch)
        ret = []
        @twitter.timeline_for(:friends, :since => since.gmtime + 1) do |status|
            unless has_been_fetched?(status) || (!RECEIVE_OWN_TWITS && is_own_twit?(status))
                ret << { :author  => status.user.name,
                         :nick    => status.user.screen_name,
                         :message => status.text,
                         :time    => status.created_at } 
            end
        end
        @last_fetch = ret.last[:time] + 1 unless ret.size == 0
    
        ret.reverse
    end
    
    protected
    def is_own_twit?(status)
        status.user.screen_name == status.client.instance_variable_get('@login')
    end
end