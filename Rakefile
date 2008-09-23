require 'rubygems'
require "rake/gempackagetask"
require "rake/rdoctask"
require "rake/testtask"
require 'echoe'
require 'lib/rtwittbot.rb'

Echoe.new('rtwittbot', RTwittBot::VERSION) do |p|
    p.author      = 'Jesús García Sáez'
    p.email       = 'blaxter@gmail.com'
    p.summary     = 'Personal twitter Jabber Bot'
    #p.install_message = 'Please, you need to edit ~/.rtwitbot.yaml file with your configuration'
    p.runtime_dependencies = [ 'twitter4r', 'xmpp4r', 'daemons', 'idn' ]
end
