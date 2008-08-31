#!/usr/bin/env ruby

require 'rubygems'
require 'time'
require 'base64'
require 'xmpp4r/client'
require 'xmpp4r/roster'
require 'xmpp4r/vcard'
require 'twitter'

# --------------------------------------------------------------------------------------------------
# Classes 
# --------------------------------------------------------------------------------------------------

class JabberBot
    include Jabber
    # user: like foobar@gmail.com
    # password: like foobarfoobar
    # server: like talk.google.com, it's optional, normally you take this value from the user
    def initialize(user, password, server = nil)
        @bot = Client.new(JID.new(user))
        @bot.connect(server)
        @bot.auth(password)
        @bot.send(Presence.new.set_type(:available))
        
        @buddy_list = Roster::Helper.new(@bot)
        @buddy_list.add_subscription_request_callback do |item, pres| 
            @buddy_list.accept_subscription(pres.from) if is_allowed? pres.from
        end

        Thread.new { loop{ @bot.send(Presence::new); sleep 60 } }
    end

    def screen_name(name)
        vcard = Jabber::Vcard::IqVcard.new
        vcard["FN"]       = name
        vcard["NICKNAME"] = name
        begin
          vcard_helper = Vcard::Helper.new(@bot).set(vcard)
        rescue
          puts "#{Time.now} vcard operation failed" 
        end
    end
    
    def set_status(state)
        @bot.send(Presence.new.set_status(state))
    end

    def add_allowed_user(user)
        unless is_allowed? user
            @bot.send(Presence.new.set_type(:subscribe).set_to(user))
        end
    end

    def each_message(&block)
        @bot.add_message_callback{|m| block[m.from, m.body] if is_allowed? m.from }
    end

    def say_to(user, message)
        @bot.send(Message.new(user, message).set_type(:chat).set_id('1')) if is_allowed? user 
    end

    protected
    def is_allowed? user
        @buddy_list[user]
    end
end

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


class TwitterJabberBot
    def initialize(jabber_data, twitter_data, jabber_user)
        @bot     = JabberBot.new(jabber_data[:user], jabber_data[:password], jabber_data[:server])
        @twitter = TwitterHandle.new(twitter_data[:user], twitter_data[:password])

        @user    = jabber_user

        @bot.add_allowed_user jabber_user
        @bot.screen_name BOT_NAME
        @bot.each_message do |from, message|
             # To allow several users, here we should get the properly TwitterHandle 
             # according to +from+ variable
             @twitter.twit message
        end
        bot_default_status
    end

    def go!
        loop do
            begin
                @twitter.timeline.each do |twit|
                    # To allow several users, we have to make relationship between @twitter & @user
                    bot_default_status if @unavailable
                    @bot.say_to @user, format_message(twit)
                end
            rescue Exception => e
                puts " #{Time.now} Exception catched: #{e}"
                bot_error_status e
            end
            sleep SLEEP_TIME_IN_SEC
        end
    end

    protected
    def format_message(twit)
        "#{twit[:author]} (#{twit[:nick]}): #{twit[:message]}"
    end

    def bot_default_status
        @bot.set_status ''         
        @bot.screen_name BOT_NAME    
        @unavailable = false
    end

    def bot_error_status(e)
        @bot.set_status "#{e}"
        @bot.screen_name(BOT_NAME + " (ERROR)")
        @unavailable = true
    end
end
