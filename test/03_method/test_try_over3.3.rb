require "test_helper"
require "try_over3.3"

class TestTryOver03Q1 < Minitest::Test
  def test_q1_called_run_test
    a1 = A1.new
    mock = MiniTest::Mock.new
    a1.stub(:run_test, mock) do
      a1.test_hoge
    end
    assert mock.verify
  end

  def test_q1_run_raise_error
    assert_raises(NoMethodError) { A1.new.testhoge }
  end

  def test_q2_proxy_hoge
    source = A2.new("hoge", "hogehoge")
    assert_equal "hogehoge", A2Proxy.new(source).hoge
  end

  def test_q2_proxy_rand
    name = alpha_rand
    source = A2.new(name, "hogehoge")
    assert_equal "hogehoge", A2Proxy.new(source).public_send(name)
  end

  def test_q2_proxy_respond_to_hoge
    source = A2.new("hoge", "hogehoge")
    assert_respond_to A2Proxy.new(source), :hoge
  end

  def test_q2_proxy_methods_not_included_hoge
    source = A2.new("hoge", "hogehoge")
    refute_includes A2Proxy.new(source).methods, :hoge
  end

  def test_q3_original_accessor_boolean_method
    klass = Class.new do
      include OriginalAccessor2
      my_attr_accessor :hoge
    end.new

    klass.hoge = true
    assert_equal(true, klass.hoge?)
    klass.hoge = "hoge"
    assert_raises(NoMethodError) { klass.hoge? }
    refute_includes(klass.methods, :hoge?)
  end

  def test_q4_call_class
    A4.runners = [:Hoge]
    assert_equal "run Hoge", A4::Hoge.run
  end

  def test_q4_raise_error_when_called_not_runner_class
    A4.runners = [:Hoge]
    assert_raises(NameError) { A4::Foo }
  end

  def test_q4_not_exists_runner_class
    A4.runners = [:Hoge]
    refute_includes(A4.constants, :Hoge)
  end

  def test_q5_task_helper_call_method
    skip
    assert_equal("foo", A5Task.foo)
  end

  def test_q5_task_heloer_not_exists_class
    skip
    refute_includes A5Task.constants, :Foo
  end

  def test_q5_task_helper_call_class
    skip
    assert_equal("foo", A5Task::Foo.run)
  end

  def test_q5_task_helper_call_class_with_warn
    skip
    _, err = capture_io do
      A5Task::Foo.run
    end
    assert_match "Warning: A5Task::Foo.run is duplicated", err
  end

  private

  def alpha_rand(size = 8)
    alphabets = [*"a".."z"]
    (0..size).map { alphabets[rand(alphabets.size)] }.join
  end
end

