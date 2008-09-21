#!/usr/bin/env ruby

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
             if message.match(/.+ \([^(]+\): .+/)
                 puts "ERROR: trying to send a fetched twit? #{Time.now}, #{from} -- #{message}" if $DEBUG
             else
                 @twitter.twit message
             end
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
