require 'test_helper'
require '02_simple_mock'
require 'securerandom'

class TestSimpleMock < MiniTest::Test
  class ClassForMockTest
    def hoge; "hoge"; end
  end

  def test_mock_initialize
    obj = SimpleMock.new
    assert_kind_of SimpleMock, obj
  end

  def test_mock_extend
    obj = ClassForMockTest.new
    SimpleMock.mock(obj)

    assert_kind_of SimpleMock, obj
  end

  def test_mock_retuns_setted_value_when_instance
    obj = SimpleMock.new
    expected = SecureRandom.hex
    obj.expects(:imitated_method, expected)

    assert_equal obj.imitated_method, expected
  end

  def test_mock_returns_setted_value_when_extended
    obj = ClassForMockTest.new
    SimpleMock.mock(obj)
    expected = SecureRandom.hex
    obj.expects(:imitated_method, expected)

    assert_equal obj.imitated_method, expected
  end

  def test_mock_counts_how_many_times_called_method
    obj = SimpleMock.mock(ClassForMockTest.new)
    obj.watch(:hoge)

    obj.hoge
    obj.hoge
    obj.hoge

    assert_equal 3, obj.called_times(:hoge)
  end

  def test_mock_counts_how_many_times_called_mocked_method
    obj = SimpleMock.new
    obj.expects(:imitated_method, true)
    obj.watch(:imitated_method)

    obj.imitated_method
    obj.imitated_method

    assert_equal 2, obj.called_times(:imitated_method)
  end

  def test_mock_returns_value_and_counts_how_many_times
    obj = SimpleMock.new
    obj.expects(:imitated_method, 'hoge')
    obj.watch(:imitated_method)

    assert_equal('hoge', obj.imitated_method)
    assert_equal('hoge', obj.imitated_method)

    assert_equal 2, obj.called_times(:imitated_method)
  end
end
