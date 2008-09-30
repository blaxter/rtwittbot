require 'rubygems'

gem 'xmpp4r'
gem 'idn'
require 'xmpp4r/client'
require 'xmpp4r/roster'
require 'xmpp4r/vcard'

class JabberBot
    include Jabber
    include Loggeable

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

        # I think this is not neccesary
        #Thread.new { loop{ @bot.send(Presence::new); sleep 60 } }
    end

    def screen_name(name)
        vcard             = Jabber::Vcard::IqVcard.new
        vcard["FN"]       = name
        vcard["NICKNAME"] = name
        Vcard::Helper.new(@bot).set(vcard)
    rescue Exception => e
        log_error e
    end

    def set_status(state)
        @bot.send(Presence.new.set_status(state))
    rescue Exception => e
        log_error e
    end

    def add_allowed_user(user)
        unless is_allowed? user
            @bot.send(Presence.new.set_type(:subscribe).set_to(user))
        end
    rescue Exception => e
        log_error e
    end

    def each_message(&block)
        @bot.add_message_callback do |m|
            begin
                block[m.from, m.body] if is_allowed? m.from
            rescue Exception => e
                log_error e
            end
        end
    end

    def say_to(user, message)
        @bot.send(Message.new(user, message).set_type(:chat).set_id('1')) if is_allowed? user
    rescue Exception => e
        log_error e
    end


    protected

    def is_allowed? user
        @buddy_list[user]
    end
end
