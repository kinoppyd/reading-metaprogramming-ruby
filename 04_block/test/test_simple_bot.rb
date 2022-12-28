require 'test_helper'
require 'securerandom'
require '03_simple_bot'

class TestSimpleBot < MiniTest::Test
  def bot_for_test(&block)
    Class.new(SimpleBot, &block)
  end

  def test_response
    klass = bot_for_test do
      respond 'hello' do
        'Yo'
      end
    end

    assert_equal 'Yo', klass.new.ask('hello')
  end

  def test_no_response
    klass = bot_for_test do
      respond 'yo' do
        'yo'
      end
    end

    assert_nil klass.new.ask("hello")
  end

  def test_global_setting
    klass = bot_for_test do
      setting :name, 'bot'
      respond 'what is your name?' do
        "i'm #{settings.name}"
      end
    end

    assert_equal "i'm bot", klass.new.ask("what is your name?")
  end

  def test_global_setting_random
    code = SecureRandom.hex

    klass = bot_for_test do
      setting :code, code
      respond 'tell me your code' do
        "code is #{settings.code}"
      end
    end

    assert_equal "code is #{code}", klass.new.ask('tell me your code')
  end

  def test_global_setting_multiple_call
    klass = bot_for_test do
      setting :name, 'bot'
      setting :age, 10
      respond 'what is your name?' do
        "i'm #{settings.name}"
      end
      respond 'how old are you?' do
        "i'm #{settings.age} years old"
      end
    end

    assert_equal "i'm bot", klass.new.ask("what is your name?")
    assert_equal "i'm 10 years old", klass.new.ask("how old are you?")
  end
end
