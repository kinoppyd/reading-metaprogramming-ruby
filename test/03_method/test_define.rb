require 'test_helper'
require '02_define'
require 'securerandom'

class TestDefine < MiniTest::Test

  begin
    class A3
      include OriginalAccessor
      my_attr_accessor :hoge
    end
  rescue
  end

  def test_answer_a1
    assert_equal "//", A1.new.send("//".to_sym)
  end

  def test_answer_a1_define
    assert_equal true, A1.new.methods.include?("//".to_sym)
  end

  def test_answer_a2
    instance = A2.new(["hoge", "fuga"])

    assert_equal true, instance.methods.include?(:dev_team)
    assert_equal "SmartHR Dev Team", instance.hoge_hoge(nil)
    assert_equal "hoge_hogehoge_hoge", instance.hoge_hoge(2)
    assert_equal "hoge_fugahoge_fugahoge_fuga", instance.hoge_fuga(3)

    another_instance = A2.new([])
    assert_equal false, another_instance.methods.include?(:hoge_hoge)
    assert_equal false, another_instance.methods.include?(:hoge_fuga)
  end

  def test_answer_a2_number
    instance = A2.new([1, 2])

    assert_equal true, instance.methods.include?(:dev_team)
    assert_equal "SmartHR Dev Team", instance.hoge_1(nil)
    assert_equal "hoge_1hoge_1", instance.hoge_1(2)
    assert_equal "hoge_2hoge_2hoge_2", instance.hoge_2(3)

    another_instance = A2.new([])
    assert_equal false, another_instance.methods.include?(:hoge_1)
    assert_equal false, another_instance.methods.include?(:hoge_2)
  end

  def test_answer_a2_random_name
    value_one = SecureRandom.hex
    value_two = SecureRandom.hex

    instance = A2.new([value_one, value_two])
    assert_equal true, instance.methods.include?(:dev_team)
    assert_equal "SmartHR Dev Team", instance.send("hoge_#{value_one}".to_sym, nil)
    assert_equal "hoge_#{value_one}hoge_#{value_one}", instance.send("hoge_#{value_one}".to_sym, 2)
    assert_equal "hoge_#{value_two}hoge_#{value_two}hoge_#{value_two}", instance.send("hoge_#{value_two}".to_sym, 3)

    another_instance = A2.new([])
    assert_equal false, another_instance.methods.include?("hoge_#{value_one}".to_sym)
    assert_equal false, another_instance.methods.include?("hoge_#{value_two}".to_sym)
  end

  def test_answer_a2_called_dev_team
    instance = A2.new([1])

    @called_dev_team = false
    trace = TracePoint.new(:call) do |tp|
      @called_dev_team = tp.event == :call && tp.method_id == :dev_team unless @called_dev_team
    end
    trace.enable
    instance.hoge_1(nil)
    trace.disable

    assert_equal true, @called_dev_team
  end

  def test_answer_a3_define
    assert_equal true, A3.methods.include?(:my_attr_accessor)
  end

  def test_answer_a3_string
    instance = A3.new
    instance.hoge = "1"

    assert_equal false, instance.methods.include?(:hoge?)
    assert_equal "1", instance.hoge
  end

  def test_answer_a3_number
    instance = A3.new
    instance.hoge = 1

    assert_equal false, instance.methods.include?(:hoge?)
    assert_equal 1, instance.hoge
  end

  def test_answer_a3_array
    instance = A3.new
    instance.hoge = [1, 2]

    assert_equal false, instance.methods.include?(:hoge?)
    assert_equal [1, 2], instance.hoge
  end

  def test_answer_a3_boolean_true
    instance = A3.new
    instance.hoge = true
    assert_equal true, instance.methods.include?(:hoge?)
    assert_equal true, instance.hoge?
  end

  def test_answer_a3_boolean_false
    instance = A3.new
    instance.hoge = false
    assert_equal true, instance.methods.include?(:hoge?)
    assert_equal false, instance.hoge?
  end
end
