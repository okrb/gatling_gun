require "json"
require "net/https"
require "openssl"
require "time"
require "uri"

require "gatling_gun/api_call"
require "gatling_gun/bang_method"
require "gatling_gun/response"

class GatlingGun  
  VERSION = "0.0.3"

  extend GatlingGun::BangMethod
  
  def initialize(api_user, api_key)
    @api_user = api_user
    @api_key  = api_key
  end
  
  ###################
  ### Newsletters ###
  ###################
  
  def add_newsletter(newsletter, details)
    fail ArgumentError, "details must be a Hash" unless details.is_a? Hash
    %w[identity subject].each do |field|
      unless details[field.to_sym] or details[field]
        fail ArgumentError, "#{field} is a required detail"
      end
    end
    unless details[:text] or details["text"] or
           details[:html] or details["html"]
      fail ArgumentError, "either text or html must be provided as a detail"
    end
    make_api_call("add", details.merge(name: newsletter))
  end
  bang_method :add_newsletter

  def edit_newsletter(newsletter, details)
    fail ArgumentError, "details must be a Hash"  unless details.is_a? Hash
    fail ArgumentError, "details cannot be empty" if     details.empty?
    make_api_call("edit", details.merge(name: newsletter))
  end
  bang_method :edit_newsletter

  def get_newsletter(newsletter)
    make_api_call("get", name: newsletter)
  end
  bang_method :get_newsletter

  def list_newsletters(newsletter = nil)
    parameters        = { }
    parameters[:name] = newsletter if newsletter
    make_api_call("list", parameters)
  end
  bang_method :list_newsletters
  
  def delete_newsletter(newsletter)
    make_api_call("delete", name: newsletter)
  end
  bang_method :delete_newsletter
  
  #############
  ### Lists ###
  #############
  
  def add_list(list, details = { })
    fail ArgumentError, "details must be a Hash" unless details.is_a? Hash
    make_api_call("lists/add", details.merge(list: list))
  end
  bang_method :add_list
  
  def edit_list(list, details = { })
    fail ArgumentError, "details must be a Hash"  unless details.is_a? Hash
    fail ArgumentError, "details cannot be empty" if     details.empty?
    make_api_call("lists/edit", details.merge(list: list))
  end
  bang_method :edit_list
  
  def get_list(list = nil)
    parameters        = { }
    parameters[:list] = list if list
    make_api_call("lists/get", parameters)
  end
  alias_method :list_lists, :get_list
  bang_method :get_list, :list_lists
  
  def delete_list(list)
    make_api_call("lists/delete", list: list)
  end
  bang_method :delete_list
  
  ##############
  ### Emails ###
  ##############
  
  def add_email(list, data)
    json_data = case data
                when Hash  then data.to_json
                when Array then data.map(&:to_json)
                else            fail ArgumentError,
                                     "details must be a Hash or Array"
                end
    make_api_call("lists/email/add", list: list, data: json_data)
  end
  alias_method :add_emails, :add_email
  bang_method :add_email, :add_emails
  
  def get_email(list, emails = nil)
    parameters         = {list: list}
    parameters[:email] = emails if emails
    make_api_call("lists/email/get", parameters)
  end
  alias_method :get_emails,  :get_email
  alias_method :list_emails, :get_email
  bang_method :get_email, :get_emails, :list_emails
  
  def delete_email(list, emails)
    make_api_call("lists/email/delete", list: list, email: emails)
  end
  alias_method :delete_emails, :delete_email
  bang_method :delete_email, :delete_emails
  
  ################
  ### Identity ###
  ################
  
  def add_identity(identity, details)
    fail ArgumentError, "details must be a Hash" unless details.is_a? Hash
    %w[name email address city state zip country].each do |field|
      unless details[field.to_sym] or details[field]
        fail ArgumentError, "#{field} is a required detail"
      end
    end
    make_api_call("identity/add", details.merge(identity: identity))
  end
  bang_method :add_identity
  
  def edit_identity(identity, details)
    fail ArgumentError, "details must be a Hash"  unless details.is_a? Hash
    fail ArgumentError, "details cannot be empty" if     details.empty?
    make_api_call("identity/edit", details.merge(identity: identity))
  end
  bang_method :edit_identity
  
  def get_identity(identity)
    make_api_call("identity/get", identity: identity)
  end
  bang_method :get_identity
  
  def list_identities(identity = nil)
    parameters            = { }
    parameters[:identity] = identity if identity
    make_api_call("identity/list", parameters)
  end
  bang_method :list_identities
  
  def delete_identity(identity)
    make_api_call("identity/delete", identity: identity)
  end
  bang_method :delete_identity
  
  ##################
  ### Recipients ###
  ##################
  
  def add_recipient(newsletter, list)
    make_api_call("recipients/add", name: newsletter, list: list)
  end
  alias_method :add_recipients, :add_recipient
  bang_method :add_recipient, :add_recipients

  def get_recipient(newsletter)
    make_api_call("recipients/get", name: newsletter)
  end
  alias_method :get_recipients,  :get_recipient
  alias_method :list_recipients, :get_recipient
  bang_method :get_recipient, :get_recipients, :list_recipients
  
  def delete_recipient(newsletter, list)
    make_api_call("recipients/delete", name: newsletter, list: list)
  end
  alias_method :delete_recipients, :delete_recipient
  bang_method :delete_recipient, :delete_recipients
  
  #################
  ### Schedules ###
  #################
  
  def add_schedule(newsletter, details = { })
    parameters      = {after: details[:after]}
    parameters[:at] = details[:at].iso8601.sub("T", " ") \
      if details[:at].respond_to? :iso8601
    if not details[:after].nil? and ( not details[:after].is_a?(Integer) or 
                                      details[:after] < 1 )
      fail ArgumentError, "after must be a positive integer"
    end
    make_api_call("schedule/add", parameters.merge(name: newsletter))
  end
  bang_method :add_schedule
  
  def get_schedule(newsletter)
    make_api_call("schedule/get", name: newsletter)
  end
  bang_method :get_schedule
  
  def delete_schedule(newsletter)
    make_api_call("schedule/delete", name: newsletter)
  end
  bang_method :delete_schedule
  
  #######
  private
  #######
  
  def make_api_call(action, parameters = { })
    ApiCall.new( action, parameters.merge( api_user: @api_user,
                                           api_key:  @api_key ) ).response
  end
end
