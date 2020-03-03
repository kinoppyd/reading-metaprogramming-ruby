# Q1.
# 次の動作をする A1 class を実装する
# - "//" を返す "//"メソッドが存在すること
class A1
  define_method('//') { '//' }
end

# Q2.
# 次の動作をする A2 class を実装する
# - 1. "SmartHR Dev Team"と返すdev_teamメソッドが存在すること
# - 2. initializeに渡した配列に含まれる値に対して、"hoge_" をprefixを付与したメソッドが存在すること
# - 2で定義するメソッドは下記とする
#   - 受け取った引数の回数分、メソッド名を繰り返した文字列を返すこと
#   - 引数がnilの場合は、dev_teamメソッドを呼ぶこと
class A2
  def initialize(ary)
    ary.each do |val|
      self.class.define_method("hoge_#{val}") do |param|
        return dev_team if param.nil?
        __method__.to_s * param
      end
    end
  end

  def dev_team
    'SmartHR Dev Team'
  end
end

# # Q3.
# # 次の動作をする OriginalAccessor モジュール を実装する
# # - OriginalAccessorモジュールはincludeされたときのみ、my_attr_accessorメソッドを定義すること
# # - my_attr_accessorはgetter/setterに加えて、boolean値を代入した際のみ真偽値判定を行うaccessorと同名の?メソッドができること
module OriginalAccessor
  def self.included(base)
    base.extend ClassMethods
  end

  module ClassMethods
    def my_attr_accessor(attribute)
      define_method(attribute) do
        instance_variable_get("@#{attribute}")
      end

      define_method("#{attribute}=") do |val|
        instance_variable_set "@#{attribute}", val
        if val.is_a?(TrueClass) || val.is_a?(FalseClass)
          self.class.define_method("#{attribute}?") { val }
        else
          self.class.undef_method("#{attribute}?") if self.class.method_defined?("#{attribute}?")
        end
      end
    end
  end
end
