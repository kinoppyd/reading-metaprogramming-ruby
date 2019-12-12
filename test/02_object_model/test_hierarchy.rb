require 'test_helper'
require 'hierarchy'

class TestHierarchy < MiniTest::Test
  def test_c1_ancestors
    assert_equal [C1, M1], C1.ancestors.first(2)
  end

  def test_c1_name
    assert_equal 'C1', C1.new.name
  end

  def test_c2_ancestors
    assert_equal [M1, C2], C2.ancestors.first(2)
  end

  def test_c2_name
    assert_equal 'M1', C2.new.name
  end

  def test_c3_ancestors
    assert_equal [M1, C3, M2, M3, MySuperClass, M4], C3.ancestors.first(6)
  end

  def test_c3_name
    assert_equal 'M1', C3.new.name
  end

  def test_c3_super_class
    assert MySuperClass.kind_of?(Class)
  end

  def test_c4_increment
    c4 = C4.new
    assert_equal "1", c4.increment
    assert_equal "2", c4.increment
    assert_equal "3", c4.increment
  end

  def test_c4_value_called
    c4 = C4.new
    c4.singleton_class.class_eval do
      private

      def value=(x)
        @called_setter = true
        @value = x
      end

      def value
        @called_getter = true
        if defined?(@value)
          @value
        else
          nil
        end
      end
    end
    c4.instance_variable_set(:"@called_setter", nil)
    c4.instance_variable_set(:"@called_getter", nil)

    assert_equal "1", c4.increment
    assert c4.instance_variable_get(:"@called_setter")
    assert c4.instance_variable_get(:"@called_getter")
  end

  def test_c4_value_methods
    assert C4.private_instance_methods.include?(:value)
    assert C4.private_instance_methods.include?(:value=)
  end

  def test_c5_another_name
    assert_equal "M1", C5.new.another_name
  end

  def test_c5_other_name
    assert_equal "Refined M1", C5.new.other_name
  end

  def test_c6_name
    assert_equal "Refined M1", C6.new.name
  end
end
