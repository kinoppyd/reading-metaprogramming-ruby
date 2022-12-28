require 'test_helper'

class AcceptBlock
  class << self
    attr_accessor :result
  end

  def self.call(&block)
    @result = block == MY_LAMBDA
  end
end

require '01_block_first_step'

class TestBlockFirstStep < MiniTest::Test
  def test_my_math
    assert_equal 4, MyMath.new.two_times { 2 }
  end

  def test_accept_block
    assert AcceptBlock.result
  end

  def test_my_block
    assert_equal(MY_LAMBDA, MyBlock.new.block_to_proc(&MY_LAMBDA))
  end

  def test_my_closure
    m1 = MyClosure.new
    m2 = MyClosure.new
    assert_equal(1, m1.increment)
    assert_equal(2, m2.increment)
    assert_equal(3, m1.increment)
    MyClosure
  end
end
