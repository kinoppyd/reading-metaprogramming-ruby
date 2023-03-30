require 'test_helper'
require '02_evil_mailbox'
require 'securerandom'

class TestEvilMailbox < MiniTest::Test
  def evil_mailbox(&block)
    mock = MiniTest::Mock.new
    mock.instance_eval(&block) if block_given?
    [EvilMailbox.new(mock), mock]
  end

  def test_send_mail
    mb, mock = evil_mailbox do
      expect :send_mail, true, ["ppyd", "hello"]
    end
    mb.send_mail("ppyd", "hello")
    mock.verify
  end

  def test_send_mail_returns_nil
    mb, _ = evil_mailbox do
      expect :send_mail, true, ["ppyd", "hello"]
    end
    assert_nil mb.send_mail("ppyd", "hello")
  end

  def test_receive_mail
    mb, mock = evil_mailbox do
      expect :receive_mail, ["kino", "Yo"]
    end
    f, t = mb.receive_mail
    mock.verify
    assert_equal "kino", f
    assert_equal "Yo", t
  end

  def test_send_mail_exec_block_with_result_true
    mb, _ = evil_mailbox do
      expect :send_mail, true, ["ppyd", "hello"]
    end
    ret = nil
    mb.send_mail("ppyd", "hello") do |res|
      ret = res
    end
    assert_equal true, ret
  end

  def test_send_mail_exec_block_with_result_false
    mb, _ = evil_mailbox do
      expect :send_mail, false, ["ppyd", "hello"]
    end
    ret = nil
    mb.send_mail("ppyd", "hello") do |res|
      ret = res
    end
    assert_equal false, ret
  end

  def test_mail_object_auth
    secret_string = SecureRandom.hex
    mock = MiniTest::Mock.new
    mock.expect :auth, true, [String]
    EvilMailbox.new(mock, secret_string)
    mock.verify
  end

  def test_send_mail_with_secret_string
    secret_string = SecureRandom.hex
    mock = MiniTest::Mock.new
    mock.expect :auth, true, [String]
    mock.expect :send_mail, true, ["ppyd", "hello#{secret_string}"]
    mb = EvilMailbox.new(mock, secret_string)

    mb.send_mail("ppyd", "hello")
    mock.verify
  end

  def test_no_secret_string_in_object
    secret_string = SecureRandom.hex
    mock = MiniTest::Mock.new
    mock.expect :auth, true, [String]
    mb = EvilMailbox.new(mock, secret_string)

    mock.verify
    mb.class.send(:class_variables).each do |cv|
      assert_equal false, secret_string == mb.class.get_class_variable(cv)
    end
    mb.send(:instance_variables).each do |iv|
      assert_equal false, secret_string == mb.instance_variable_get(iv)
    end
  end

  def evil_mailbox_with_secret_string(secret_string, &block)
    mock = MiniTest::Mock.new
    mock.instance_eval(&block) if block_given?
    [EvilMailbox.new(mock, secret_string), mock]
  end

  def test_send_mail_exec_block_with_result_true_and_secret_string
    secret_string = SecureRandom.hex
    mb, mock = evil_mailbox_with_secret_string(secret_string) do
      expect :auth, true, [String]
      expect :send_mail, true, ["ppyd", "hello#{secret_string}"]
    end

    ret = nil
    mb.send_mail("ppyd", "hello") do |res|
      ret = res
    end
    mock.verify
    assert_equal true, ret
  end
end
