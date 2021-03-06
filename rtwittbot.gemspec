
# Gem::Specification for Rtwittbot-0.1
# Originally generated by Echoe

--- !ruby/object:Gem::Specification 
name: rtwittbot
version: !ruby/object:Gem::Version 
  version: "0.1"
platform: ruby
authors: 
- "Jes\xC3\xBAs Garc\xC3\xADa S\xC3\xA1ez"
autorequire: 
bindir: bin

date: 2008-09-24 00:00:00 +02:00
default_executable: 
dependencies: 
- !ruby/object:Gem::Dependency 
  name: twitter4r
  type: :runtime
  version_requirement: 
  version_requirements: !ruby/object:Gem::Requirement 
    requirements: 
    - - ">="
      - !ruby/object:Gem::Version 
        version: "0"
    version: 
- !ruby/object:Gem::Dependency 
  name: xmpp4r
  type: :runtime
  version_requirement: 
  version_requirements: !ruby/object:Gem::Requirement 
    requirements: 
    - - ">="
      - !ruby/object:Gem::Version 
        version: "0"
    version: 
- !ruby/object:Gem::Dependency 
  name: daemons
  type: :runtime
  version_requirement: 
  version_requirements: !ruby/object:Gem::Requirement 
    requirements: 
    - - ">="
      - !ruby/object:Gem::Version 
        version: "0"
    version: 
- !ruby/object:Gem::Dependency 
  name: idn
  type: :runtime
  version_requirement: 
  version_requirements: !ruby/object:Gem::Requirement 
    requirements: 
    - - ">="
      - !ruby/object:Gem::Version 
        version: "0"
    version: 
- !ruby/object:Gem::Dependency 
  name: echoe
  type: :development
  version_requirement: 
  version_requirements: !ruby/object:Gem::Requirement 
    requirements: 
    - - ">="
      - !ruby/object:Gem::Version 
        version: "0"
    version: 
description: Personal twitter Jabber Bot
email: blaxter@gmail.com
executables: 
- rtwittbotd
- rtwittbot.rb
extensions: []

extra_rdoc_files: 
- LICENSE
- bin/rtwittbotd
- bin/rtwittbot.rb
- lib/rtwittbot/twitter_handle.rb
- lib/rtwittbot/twitter_jabber_bot.rb
- lib/rtwittbot/config.rb
- lib/rtwittbot/jabber_bot.rb
- lib/rtwittbot.rb
- README
files: 
- LICENSE
- bin/rtwittbotd
- bin/rtwittbot.rb
- Manifest
- HISTORY
- lib/rtwittbot/twitter_handle.rb
- lib/rtwittbot/twitter_jabber_bot.rb
- lib/rtwittbot/config.rb
- lib/rtwittbot/jabber_bot.rb
- lib/rtwittbot.rb
- README
- Rakefile
- rtwittbot.gemspec
has_rdoc: true
homepage: ""
post_install_message: 
rdoc_options: 
- --line-numbers
- --inline-source
- --title
- Rtwittbot
- --main
- README
require_paths: 
- lib
required_ruby_version: !ruby/object:Gem::Requirement 
  requirements: 
  - - ">="
    - !ruby/object:Gem::Version 
      version: "0"
  version: 
required_rubygems_version: !ruby/object:Gem::Requirement 
  requirements: 
  - - "="
    - !ruby/object:Gem::Version 
      version: "1.2"
  version: 
requirements: []

rubyforge_project: rtwittbot
rubygems_version: 1.2.0
specification_version: 2
summary: Personal twitter Jabber Bot
test_files: []
