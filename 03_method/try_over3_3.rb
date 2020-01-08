# Q1
# 以下のクラス A1 を修正して、`test_` から始まるインスタンスメソッドが実行された場合は `run_test` メソッドを実行されるようにしてください。
class A1
  def run_test ; end
end

# Q2
# 以下のクラス A2 はinitializeにnameとvalueをとり、nameの名前でvalueを返すreaderメソッドが動的に生成されます。
# A2Proxy にのみコードを追加して A2 に動的に生成されるメソッドと同様の名前、戻り値のメソッドを A2Proxy が実行できるようにしてください。
# またその際 `respond_to? name` をしても true が返されるようにしてください。
class A2
  def initialize(name, value)
    instance_variable_set("@#{name}", value)
    self.class.attr_reader name.to_sym
  end
end

class A2Proxy
  def initialize(source)
    @source = source
  end
end

# Q3
# 前回 OriginalAccessor の my_attr_accessor で定義した getter/setter に boolean の値が入っている場合には #{name}? が定義されるようなモジュールを実装しました。
# 今回は、そのモジュールに boolean 以外が入っている場合には hoge? メソッドが存在しないように変更を加えてください。
# （以下は god の模範解答を一部変更したものです。以下のコードに変更を加えてください）
module OriginalAccessor2
  def self.included(mod)
    mod.define_singleton_method :my_attr_accessor do |attr_sym|
      define_method attr_sym do
        @attr
      end

      define_method "#{attr_sym}=" do |value|
        if [true, false].include?(value) && !respond_to?("#{attr_sym}?")
          self.class.define_method "#{attr_sym}?" do
            @attr == true
          end
        end
        @attr = value
      end
    end
  end
end

# Q4
# 以下の A4 クラスには新しくクラスを定義せずに以下のように動作するクラスを完成させてください
# A4.runners = [:Hoge]
# A4::Hoge.run
# # => "run Hoge"
class A4
  self.class.attr_accessor :runners
end

# Q5. チャレンジ問題！ 挑戦する方はテストの skip を外して挑戦してみてください。
#
# TaskHelper という include すると task というクラスマクロが与えらる以下のようなモジュールがあります。
module TaskHelper
  def self.included(klass)
    klass.define_singleton_method :task do |name, &task_block|
      new_klass = Class.new do
        define_singleton_method :run do
          puts "start #{Time.now}"
          block_return = task_block.call
          puts "finish #{Time.now}"
          block_return
        end
      end
      new_klass_name = name.to_s.split("_").map{ |w| w[0] = w[0].upcase; w }.join
      const_set(new_klass_name, new_klass)
    end
  end
end

# TaskHelper は include することで以下のような使い方ができます
class A5Task
  include TaskHelper

  task :foo do
    "foo"
  end
end
# irb(main):001:0> A3Task::Foo.run
# start 2020-01-07 18:03:10 +0900
# finish 2020-01-07 18:03:10 +0900
# => "foo"

# 今回 TaskHelper では A5Task::Foo のように Foo クラスを作らず A5Task.foo のようにクラスメソッドとして task で定義された名前のクラスメソッドでブロックを実行するように変更したいです。
# でも、TaskHelper はすでに A5Task::Foo.run のように生成されたクラスを使った実行している人がたくさんいます。
# 今回変更を加えても、その人たちにはこれまで通り生成されたクラスのrunメソッドでタスクを実行できるようにしておいて、warning だけだしておくようにしたいです。
# TaskHelper を修正してそれを実現してください。 なお、その際、クラスは実行されない限り生成されないものとします。
#
# 変更後想定する使い方
# メソッドを使ったケース
# irb(main):001:0> A5Task.foo
# start 2020-01-07 18:03:10 +0900
# finish 2020-01-07 18:03:10 +0900
# => "foo"
#
# クラスのrunメソッドを使ったケース
# irb(main):001:0> A5Task::Foo.run
# Warning: A5Task::Foo.run is duplicated
# start 2020-01-07 18:03:10 +0900
# finish 2020-01-07 18:03:10 +0900
# => "foo"
