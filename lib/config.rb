module RTwittBot
	module Config

    # right now, twitter has a limit of 100 request/hour, so 1 request per second is fine, i think...
    SLEEP_TIME_IN_SEC = 60 
    # if you wanna receive also your own twits
    RECEIVE_OWN_TWITS = false
    # The data for the jabber bot, you can give one account in a lot of places, for example with 
    # every gmail account you can use it for jabber
    JABBER_ACCOUNT    = { :user      => 'usuariobot@gmail.com', 
                          :password  => 'password',
                          :server    => 'talk.google.com'         }
    # Your jaber account where receive IMs from the bot
    ALLOWED_USER      = 'useraccount@gmail.com'
    # Your twitter account for getting your timeline and post new twits
    TWITTER_ACCOUNT   = { :user      => 'usuario',
                          :password  => 'password' }

    BOT_NAME = 'Twitter Bot'
	end
end
