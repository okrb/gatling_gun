require 'json'
require 'net/https'
require 'openssl'
require 'time'
require 'uri'
require 'ostruct'

require 'gatling_gun/api_call'
require 'gatling_gun/response'
require 'gatling_gun/client'

# Ruby 1.9 backports
if RUBY_VERSION.match(/1.8.7/)
  require 'gatling_gun/core_ext' 
end

module GatlingGun
  def self.configure
    config = OpenStruct.new()
    yield config
    @@client = Client.new(config.username, config.password)
  end

  def self.client
    @@client
  end
end

