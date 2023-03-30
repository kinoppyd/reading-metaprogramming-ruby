require 'test_helper'
require 'securerandom'
require '01_method_first_step'

class TestMethodFirstStep < MiniTest::Test
  def test_hello
    assert_equal F1.new.hello, 'hello'
  end

  def test_world
    assert_equal F1.world, 'world'
  end

  def test_method_missing
    assert_equal F1.new.send(SecureRandom.alphanumeric), 'NoMethodError'
  end

  def test_respond_to
    assert F1.new.respond_to?(SecureRandom.alphanumeric)
  end

  def test_add_hi
    f2 = F2.new
    refute f2.respond_to?(:hi)
    f2.add_hi
    assert f2.respond_to?(:hi)
  end
end
