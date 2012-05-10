# backport of 1.9's net/http array value handling in forms
# http://apidock.com/ruby/Net/HTTPHeader/set_form_data#1105-Backport-from-1-9

require 'cgi'
module Net
  module HTTPHeader
    def set_form_data(params, sep = '&')
      query = URI.encode_www_form(params)
      query.gsub!(/&/, sep) if sep != '&'
      self.body = query
      self.content_type = 'application/x-www-form-urlencoded'
    end
    alias form_data= set_form_data
  end
end

module URI
  def self.encode_www_form(enum)
    enum.map do |k,v|
      if v.nil?
        k
      elsif v.respond_to?(:to_ary)
        v.to_ary.map do |w|
          str = k.is_a?(Symbol) ? k.to_s : k.dup
          unless w.nil?
            str << '='
            str << CGI.escape(w)
          end
        end.join('&')
      else
        str = k.is_a?(Symbol) ? k.to_s : k.dup
        str << '='
        str << CGI.escape(v)
      end
    end.join('&')
  end
end
