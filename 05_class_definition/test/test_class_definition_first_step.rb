require 'test_helper'

class Judgement
  def self.call(e1, e2)
    @e1 = e1
    @e2 = e2
  end
end

class Judgement2
  def self.call(klass)
    @klass = klass
  end
end

class ExOver
  attr_accessor :result

  def initialize
    self.result = ''
  end

  def before
    result << 'before'
  end

  def hello
    result << 'hello'
  end

  def after
    result << 'after'
  end
end

require '01_class_definition_first_step'

class TestClassDefinitionFirstStep < MiniTest::Test
  def test_judgement
    e1 = Judgement.instance_variable_get(:@e1)
    e2 = Judgement.instance_variable_get(:@e2)
    assert e1.is_a?(ExClass)
    assert e2.is_a?(ExClass)
    refute e1.respond_to?(:hello)
    assert e2.respond_to?(:hello)
  end

  def test_judgement2
    klass = Judgement2.instance_variable_get(:@klass)
    assert klass.name.nil?
    assert klass.superclass == ExClass
  end

  def test_metaclass
    MetaClass.class_eval do
      meta_attr_accessor :hello
    end

    meta = MetaClass.new
    meta.meta_hello = 'hello'
    assert_equal 'meta hello', meta.meta_hello
  end

  def test_exconfig
    ExConfig.config = 'hello'
    assert_equal 'hello', ExConfig.config
    ex = ExConfig.new
    assert_equal 'hello', ex.config
    ex.config = 'world'
    assert_equal 'world', ExConfig.config
  end

  def test_exover
    exover = ExOver.new
    assert_equal 'beforehelloafter', exover.hello
  end

  def test_mygreeting
    assert_equal 'hi', MyGreeting.new.say
  end
end
