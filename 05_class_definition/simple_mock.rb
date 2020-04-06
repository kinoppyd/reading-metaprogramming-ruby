# 次の仕様を満たすモジュール SimpleMock を作成してください
#
# SimpleMockは、次の2つの方法でモックオブジェクトを作成できます
# 特に、2の方法では、他のオブジェクトにモック機能を付与します
# この時、もとのオブジェクトの能力が失われてはいけません
# また、これの方法で作成したオブジェクトを、以後モック化されたオブジェクトと呼びます
# 1.
# ```
# SimpleMock.new
# ```
#
# 2.
# ```
# obj = SomeClass.new
# SimpleMock.mock(obj)
# ```
#
# モック化したオブジェクトは、expectsメソッドに応答します
# expectsメソッドには2つの引数があり、それぞれ応答を期待するメソッド名と、そのメソッドを呼び出したときの戻り値です
# ```
# obj = SimpleMock.new
# obj.expects(:imitated_method, true)
# obj.imitated_method #=> true
# ```
# モック化したオブジェクトは、expectsの第一引数に渡した名前のメソッド呼び出しに反応するようになります
# そして、第2引数に渡したオブジェクトを返します
#
# モック化したオブジェクトは、watchメソッドとcalled_timesメソッドに応答します
# これらのメソッドは、それぞれ1つの引数を受け取ります
# watchメソッドに渡した名前のメソッドが呼び出されるたび、モック化したオブジェクトは内部でその回数を数えます
# そしてその回数は、called_timesメソッドに同じ名前の引数が渡された時、その時点での回数を参照することができます
# ```
# obj = SimpleMock.new
# obj.expects(:imitated_method, true)
# obj.watch(:imitated_method)
# obj.imitated_method
# obj.imitated_method
# obj.called_times(:imitated_method) #=> 2
# ```
module SimpleMock
  
  def expects(method_name, return_value)
    define_singleton_method(method_name) do
      method_called_hash[method_name] += 1 if method_called_hash.key?(:method_name)
      return_value
    end
  end

  def watch(method_name)
    method_called_hash[method_name] = 0
  end

  def called_times(method_name)
    method_called_hash[method_name]
  end

  def method_called_hash
    @method_called_hash ||= {}
  end

  class << self
    def new
      Class.new.extend(self)
    end

    def mock(obj)
      obj.extend(self)
    end
  end
end

=begin
require './05_class_definition/simple_mock'

obj = SimpleMock.new
obj.expects(:imitated_method, true)
obj.imitated_method #=> true
=end
