require 'test_helper'
require 'ghost'

class TestGhost < MiniTest::Test
  def test_answer_a3_not_define_method
    answer_three = A3.new

    assert_equal false, A3.methods(false).include?(:hoge)
    assert_equal false, A3.methods(false).include?(:fuga)
    assert_equal false, answer_three.respond_to?(:hoge)
    assert_equal false, answer_three.respond_to?(:fuga)
  end

  def test_answer_a3_ghost_method_hoge
    assert_equal "hogehoge", A3.new.hoge
  end

  def test_answer_a3_ghost_method_fuga
    assert_equal "fugafugafuga", A3.new.fuga(3)
  end

  def test_answer_a3_ghost_method_not_found
    assert_raises NoMethodError do
      A3.new.something_method
    end
  end

  def test_answer_a4_not_define_method
    answer_four = A4.new("dummy")

    assert_equal false, A4.methods(false).include?(:reverse)
    assert_equal false, A4.methods(false).include?(:reverse)
    assert_equal false, answer_four.respond_to?(:reverse)
    assert_equal false, answer_four.respond_to?(:reverse)
  end

  def test_answer_a4_proxy
    assert_equal "metaprogramming ruby の逆は ybur gnimmargorpatem", A4.new("metaprogramming ruby").reverse
  end

  def test_answer_a4_proxy_other_words
    assert_equal "SmartHR Tech Team", A4.new(nil).reverse
    assert_equal "SmartHR Tech Team", A4.new("").reverse
    assert_equal "SmartHR Tech Team", A4.new(1).reverse
  end

  def test_answer_a4_proxy_method_not_found
    assert_raises NoMethodError do
      A4.new("dummy").something_method
    end
  end

  def test_answer_a5_not_define_method
    answer_five = A5.new

    assert_equal false, A3.methods(false).include?(:find_by_hoge)
    assert_equal false, A3.methods(false).include?(:find_by_fuga)
    assert_equal false, A3.methods(false).include?(:find_by_id)
    assert_equal false, A3.methods(false).include?(:find_by_hoge_and_fuga)
    assert_equal false, answer_five.respond_to?(:find_by_hoge)
    assert_equal false, answer_five.respond_to?(:find_by_fuga)
    assert_equal false, answer_five.respond_to?(:find_by_id)
    assert_equal false, answer_five.respond_to?(:find_by_hoge_and_fuga)
  end

  def test_answer_a5_complexity_method_missing
    answer_five = A5.new

    assert_equal({ id: 1, name: "hoge" }, answer_five.find_by_hoge)
    assert_equal({ id: 2, name: "fuga" }, answer_five.find_by_fuga)
    assert_equal({ id: 1, name: "hoge" }, answer_five.find_by_id(1))
    assert_equal({ id: 2, name: "fuga" }, answer_five.find_by_id(2))
    assert_equal([{ id: 1, name: "hoge" }, { id: 2, name: "fuga" }], answer_five.find_by_hoge_and_fuga)
    assert_nil answer_five.find_by_yoga
    assert_nil answer_five.find_by_yoga_and_dummy
    assert_equal([{ id: 1, name: "hoge" }], answer_five.find_by_hoge_and_yoga)
    assert_equal([{ id: 1, name: "hoge" }], answer_five.find_by_yoga_and_hoge)
    assert_equal([{ id: 1, name: "hoge" }, { id: 2, name: "fuga" }], answer_five.find_by_yoga_and_hoge_and_fuga)
  end

  def test_answer_a5_complexity_method_missing_not_found
    assert_raises NoMethodError do
      A5.new.something_method
    end
  end
end
