require 'test_helper'
require '01_try_out'

class TestTryOut < MiniTest::Test
  def test_first_last_name
    target = TryOut.new("John", "Wick")
    assert_equal "John Wick", target.full_name
  end

  def test_first_middle_last_name
    target = TryOut.new("Keanu", "Charies",  "Reeves")
    assert_equal "Keanu Charies Reeves", target.full_name
  end

  def test_first_name_accessor
    target = TryOut.new("Henrik", "Vanger")
    target.first_name = "Martin"
    assert_equal "Martin Vanger", target.full_name
  end

  def test_upcase_full_name
    target = TryOut.new("Arthur", "Fleck")
    assert_equal "ARTHUR FLECK", target.upcase_full_name
  end

  def test_upcase_full_name_no_side_effect
    target = TryOut.new("Lorraine", "Broughton")
    target.upcase_full_name
    assert_equal "Lorraine Broughton", target.full_name
  end

  def test_upcase_full_name_bang
    target = TryOut.new("Earl", "Stone")
    assert_equal "EARL STONE", target.upcase_full_name!
  end

  def test_upcase_full_name_bang_has_side_effect
    target = TryOut.new("Murphy", "McManus")
    target.upcase_full_name!
    assert_equal "MURPHY MCMANUS", target.full_name
  end

  def test_too_few_arguments
    assert_raises (ArgumentError) {TryOut.new("John")}
  end

  def test_too_many_arguments
    assert_raises (ArgumentError) {TryOut.new("John", "Milton", "Cage", "Jr")}
  end
end

