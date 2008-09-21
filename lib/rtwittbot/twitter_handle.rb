require 'rubygems'
require 'time'
require 'twitter'

class TwitterHandle
    MAX = 10
    USER_AGENT = 'rtwittbot'

    def initialize(user, password)
        Twitter::Client.configure do |conf|
            conf.source              = USER_AGENT
            conf.user_agent          = USER_AGENT
            conf.application_name    = USER_AGENT
            conf.application_version = RTwittBot::VERSION
            conf.application_url     = 'http://github.com/blaxter/rtwittbot'
        end
        @twitter     = Twitter::Client.new(:login => user, :password => password)

        @last_fetch  = Time.now - 60 # 1 minute ago

        @_last_twits = []
    end
    
    def has_been_fetched?(r)
        fetched = @_last_twits.include? r.id
        unless fetched
            @_last_twits.delete_at 0 unless @_last_twits.size < TwitterHandle::MAX
            @_last_twits << r.id
        else
            puts "_last_twits contents: #{@_last_twits.join ', '} (id = #{r.id})"
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
        puts "Trying to get timeline since #{since.gmtime + 1}"
        last_fetch = since
        @twitter.timeline_for(:friends, :since => since.gmtime + 1) do |status|        
            unless (!RECEIVE_OWN_TWITS && is_own_twit?(status)) || has_been_fetched?(status)
                ret << { :author  => status.user.name,
                         :nick    => status.user.screen_name,
                         :message => status.text,
                         :time    => status.created_at } 
            end
            last_fetch = status.created_at if status.created_at > last_fetch
        end
        @last_fetch = last_fetch
        ret.reverse
    end
    
    protected
    def is_own_twit?(status)
        status.user.screen_name == status.client.instance_variable_get('@login')
    end
end
