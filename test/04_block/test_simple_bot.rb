require 'test_helper'
require 'securerandom'
require 'simple_bot'

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

  def test_after_filter
    klass = bot_for_test do
      respond 'hello' do
        'hello'
      end

      after(/hello/) do |res|
        res + ' men'
      end
    end

    assert_equal 'hello men', klass.new.ask('hello')
  end

  def test_some_after_filter
    klass = bot_for_test do
      respond 'hello' do
        'yo hello'
      end

      after(/hello/) do |res|
        res + ' men'
      end

      after(/yo/) do |res|
        'yo ' + res
      end
    end

    assert_equal 'yo yo hello men', klass.new.ask('hello')
  end
end
