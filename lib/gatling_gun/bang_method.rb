class GatlingGun
  module BangMethod
    def bang_method(*method_names)
      method_names.each do |method|
        define_method("#{method}!") do |*args|
          response = self.send(method, *args)
          response.verify!
          response
        end
      end
    end
  end
end
