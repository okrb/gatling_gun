require 'test/unit'
require 'gatling_gun'

class FakeResponse
  def initialize(success)
    @success = success
  end

  def verify!
    fail "Error returned!" unless @success
  end
end

class Receiver
  extend GatlingGun::BangMethod

  def some_api_call(success)
    FakeResponse.new(success)
  end

  bang_method :some_api_call
end

class BangMethodTest < Test::Unit::TestCase

  def test_raises_on_failure
    assert_raise RuntimeError do
      Receiver.new.some_api_call!(false)
    end
  end

  def test_returns_response
    assert Receiver.new.some_api_call!(true).is_a?(FakeResponse)
  end

  def test_actual_use
    assert GatlingGun.instance_methods.include?(:add_list!)
  end

end