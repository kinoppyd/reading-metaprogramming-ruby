# Q1.
#
# 問題の解説
# defだとSyntaxErrorになってしまうようなメソッド名でも、define_methodを使うことでメソッドとして定義することができます。
#
class A1
  define_method '//' do
    '//'
  end
end

# Q2
#
# 問題の解説
# defind_singleton_methodを利用して動的に特異メソッドを定義することで、条件2を満たしています。
# define_methodはModuleのインスタンスメソッドなので、initializeメソッド中では使えません。
# A2.define_methodのようにすれば使えますが、それだとA2クラスのインスタンスメソッドになるので
# すべてのA2インスタンスで利用できてしまい、
# 「メソッドが定義されるのは同時に生成されるオブジェクトのみで、別のA2インスタンスには（同じ値を含む配列を生成時に渡さない限り）定義されない」
# という仕様を満たすことができません。
#
class A2
  def initialize(ary)
    ary.each do |name|
      method_name = "hoge_#{name}"

      define_singleton_method method_name do |times|
        if times.nil?
          dev_team
        else
          method_name * times
        end
      end
    end
  end

  def dev_team
    'SmartHR Dev Team'
  end
end

# Q3.
#
# 問題の解説
# 3章にはまだ登場していない概念ですが、includedフックを利用してモジュールがincludeされたときの振る舞いを記述しています。
# my_attr_accessorメソッドはクラスメソッドに相当するため、includedメソッドの引数として渡されてきたクラスに直接define_singleton_methodでメソッドを追加しています。
# さらにmy_attr_accessorメソッド実行時にインスタンスメソッドを追加するためにdefine_methodを利用しています。
# `?`つきのメソッドを定義するために、セッター実行時にdefine_aingleton_methodでメソッドを追加しています。
#
module OriginalAccessor
  def self.included(base)
    base.define_singleton_method(:my_attr_accessor) do |attr|
      base.define_method attr do
        @attr
      end

      base.define_method "#{attr}=" do |value|
        @attr = value
        if value.is_a?(TrueClass) || value.is_a?(FalseClass)
          define_singleton_method "#{attr}?" do
            !!value
          end
        end
      end
    end
  end
end