require "test_helper"
require "try_over3_3"

class TestTryOver03Q1 < Minitest::Test
  def test_q1_called_run_test
    a1 = TryOver3::A1.new
    mock = MiniTest::Mock.new
    a1.stub(:run_test, mock) do
      a1.test_hoge
    end
    assert mock.verify
  end

  def test_q1_run_raise_error
    assert_raises(NoMethodError) { TryOver3::A1.new.testhoge }
  end

  def test_q1_methods_not_included_test
    assert_equal false, TryOver3::A1.instance_methods(false).any? { |method_name| method_name.to_s.start_with?("test_") }
  end

  def test_q2_proxy_foo
    source = TryOver3::A2.new("foo", "foofoo")
    assert_equal "foofoo", TryOver3::A2Proxy.new(source).foo
  end

  def test_q2_proxy_hoge_writer
    source = TryOver3::A2.new("foo", "foo")
    proxy = TryOver3::A2Proxy.new(source)
    proxy.foo = "foofoo"
    assert_equal "foofoo", proxy.foo
  end

  def test_q2_proxy_rand
    name = alpha_rand
    source = TryOver3::A2.new(name, "foo")
    assert_equal "foo", TryOver3::A2Proxy.new(source).public_send(name)
  end

  def test_q2_proxy_respond_to_foo
    source = TryOver3::A2.new("foo", "foofoo")
    assert_respond_to TryOver3::A2Proxy.new(source), :foo
  end

  def test_q2_proxy_methods_not_included_foo
    source = TryOver3::A2.new("foo", "foofoo")
    refute_includes TryOver3::A2Proxy.new(source).methods, :foo
  end

  def test_q3_original_accessor_boolean_method
    instance = orignal_accessor_included_instance
    instance.hoge = true
    assert_equal(true, instance.hoge?)
    instance.hoge = "hoge"
    assert_raises(NoMethodError) { instance.hoge? }
    refute_includes(instance.methods, :hoge?)
  end

  def test_q3_original_accessor_boolean_method_reverse
    instance = orignal_accessor_included_instance
    instance.hoge = "hoge"
    assert_raises(NoMethodError) { instance.hoge? }
    refute_includes(instance.methods, :hoge?)
    instance.hoge = true
    assert_equal(true, instance.hoge?)
  end

  def test_q4_call_class
    TryOver3::A4.runners = [:Hoge]
    assert_equal "run Hoge", TryOver3::A4::Hoge.run
  end

  def test_q4_raise_error_when_called_not_runner_class
    TryOver3::A4.runners = [:Hoge]
    assert_raises(NameError) { TryOver3::A4::Foo }
  end

  def test_q4_not_exists_runner_class
    TryOver3::A4.runners = [:Hoge]
    refute_includes(TryOver3::A4.constants, :Hoge)
  end

  def test_q5_task_helper_call_method
    assert_equal("foo", TryOver3::A5Task.foo)
  end

  def test_q5_task_heloer_not_exists_class
    refute_includes TryOver3::A5Task.constants, :Foo
  end

  def test_q5_task_helper_call_class
    assert_equal("foo", TryOver3::A5Task::Foo.run)
  end

  def test_q5_task_helper_call_class_with_warn
    _, err = capture_io do
      TryOver3::A5Task::Foo.run
    end
    assert_match "Warning: TryOver3::A5Task::Foo.run is deprecated", err
  end

  def test_q5_error_when_called_not_defined_task_class
    assert_raises(NameError) { TryOver3::A5Task::Bar.run }
  end

  private

  def alpha_rand(size = 8)
    alphabets = [*"a".."z"]
    (0..size).map { alphabets[rand(alphabets.size)] }.join
  end

  def orignal_accessor_included_instance
    Class.new do
      include TryOver3::OriginalAccessor2
      my_attr_accessor :hoge
    end.new
  end
end

