class GatlingGun
  class Response
    include Enumerable
    
    def initialize(response)
      if response.is_a? Hash
        @success            = false
        @http_response_code = nil
        @data               = response
      else
        @success            = response.is_a? Net::HTTPSuccess
        @http_response_code = response.code
        @data               = parse(response.body)
      end
    end
    
    attr_reader :http_response_code
    
    def success?
      @success
    end
    
    def error?
      not success?
    end

    def verify!
      # in some cases, a success is returned but with an error message
      # consider that a failure anyway for bang calls
      failure = error? || self['error']
      fail "API call failed - #{self['error']}" if failure
    end
    
    def error_messages
      Array(self[:errors]) + Array(self[:error])
    end
    
    def [](field)
      case @data
      when Hash
        @data[field.to_s]
      when Array
        @data[field]
      else
        nil
      end
    end
    
    def each(&iterator)
      if @data.is_a? Enumerable
        @data.each(&iterator)
      end
    end
    
    def empty?
      @data.empty?
    end
    
    #######
    private
    #######
    
    def parse(body)
      JSON.parse(body)
    rescue JSON::JSONError => error
      @success = false
      @data    = {"error" => error.message}
    end
  end
end
