def require_local(suffix)
  require(File.expand_path(File.join(File.dirname(__FILE__), suffix)))
end

require_local "config.rb"
require_local "twitter_jabber_bot.rb"

include RTwittBot::Config

TwitterJabberBot.new(JABBER_ACCOUNT, TWITTER_ACCOUNT, ALLOWED_USER).go!
