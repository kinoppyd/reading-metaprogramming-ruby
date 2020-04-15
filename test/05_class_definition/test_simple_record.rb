require 'test_helper'
require 'simple_model'
require 'securerandom'

class TestSimpleRecord < MiniTest::Test
  class Product
    include SimpleModel

    attr_accessor :name, :description
  end

  def test_accessor
    obj = Product.new(name: 'SmarterHR', description: 'more smart SmartHR')
    assert_equal 'SmarterHR', obj.name
    assert_equal 'more smart SmartHR', obj.description
  end

  def test_writer
    obj = Product.new(name: 'SmarterHR', description: 'more smart SmartHR')
    obj.name = 'Ultra SmarterHR'
    obj.description = 'more smart SmarterHR'
    assert_equal 'Ultra SmarterHR', obj.name
    assert_equal 'more smart SmarterHR', obj.description
  end

  def test_watching_not_changes_attrs
    obj = Product.new(name: 'SmarterHR', description: 'more smart SmartHR')
    assert_equal false, obj.changed?
  end

  def test_watching_changes_attrs
    obj = Product.new(name: 'SmarterHR', description: 'more smart SmartHR')
    obj.name = 'SuperSmarterHR'
    assert_equal true, obj.changed?
  end

  def test_watching_changes_each_attrs
    obj = Product.new(name: 'SmarterHR', description: 'more smart SmartHR')
    obj.name = 'SuperSmarterHR'
    assert_equal true, obj.name_changed?
    assert_equal false, obj.description_changed?
  end

  def test_restore_changes
    obj = Product.new(name: 'SmarterHR', description: 'more smart SmartHR')
    obj.name = 'Ultra SmarterHR'
    obj.description = 'more smart SmarterHR'
    obj.restore!
    assert_equal 'SmarterHR', obj.name
    assert_equal 'more smart SmartHR', obj.description
    assert_equal false, obj.changed?
  end

  def test_random_read
    name  = SecureRandom.hex
    desc  = SecureRandom.hex
    obj = Product.new(name: name, description: desc)
    assert_equal name, obj.name
    assert_equal desc, obj.description
  end

  def test_random_write
    name  = SecureRandom.hex
    desc  = SecureRandom.hex
    obj = Product.new(name: 'SmarterHR', description: 'more smart SmartHR')
    obj.name = name
    obj.description = desc
    assert_equal name, obj.name
    assert_equal desc, obj.description
  end

  class MultipleAccessorsProduct
    include SimpleModel

    attr_accessor :name
    attr_accessor :description
  end

  def test_multiple_accessors
    obj = MultipleAccessorsProduct.new(name: 'SmarterHR', description: 'more smart SmartHR')
    assert_equal 'SmarterHR', obj.name
    assert_equal 'more smart SmartHR', obj.description
  end

  def test_multiple_accessors_writer
    obj = MultipleAccessorsProduct.new(name: 'SmarterHR', description: 'more smart SmartHR')
    obj.name = 'Ultra SmarterHR'
    obj.description = 'more smart SmarterHR'
    assert_equal 'Ultra SmarterHR', obj.name
    assert_equal 'more smart SmarterHR', obj.description
  end
end
