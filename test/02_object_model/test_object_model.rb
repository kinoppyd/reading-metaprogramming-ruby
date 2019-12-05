require 'test_helper'
require 'hoge_everywhere'
require 'hoge'

class TestObjectModel < MiniTest::Test
  def test_hoge_in_string
    assert_equal "hoge","hoge".hoge
  end

  def test_hoge_in_integer
    assert_equal "hoge", 1.hoge
  end

  def test_hoge_in_numeric
    assert_equal "hoge", (1.1).hoge
  end

  def test_hoge_in_class
    assert_equal "hoge", Class.hoge
  end

  def test_hoge_in_hash
    assert_equal "hoge", ({hoge: :foo}).hoge
  end

  def test_hoge_in_true_class
    assert_equal "hoge", true.hoge
  end

  def test_hoge_const
    assert_equal "hoge", Hoge::Hoge
  end

  def test_hogehoge_method_exists_in_hoge_class
    assert Hoge.instance_methods(false).include?(:hogehoge)
  end

  def test_hogehoge_method_returns_hoge
    assert_equal "hoge", Hoge.new.hogehoge
  end

  def test_hoge_super_class_is_string
    assert_equal String, Hoge.superclass
  end

  def test_ask_hoge_myself_true
    assert Hoge.new("hoge").hoge?
  end

  def test_ask_hoge_myself_false
    refute Hoge.new("foo").hoge?
  end
end
