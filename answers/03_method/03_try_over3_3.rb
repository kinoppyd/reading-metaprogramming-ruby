TryOver3 = Module.new
# Q1. 問題の解説
#
# method_missingを利用してゴーストメソッドを作る問題です。
# respond_to_missing?はなくてもテストはパスしますが、method_missingを作るときにはセットで
# 定義しておくのがお作法なので回答例にはrespond_to_missing?も定義しています。
#
class TryOver3::A1
  def run_test
  end

  def method_missing(name, *args)
    if name.to_s.start_with?('test_')
      run_test
    else
      super
    end
  end

  def respond_to_missing?(name)
    name.to_s.start_with?('test_')
  end
end

# Q2. 問題の解説
#
# method_missingとsendを使って動的プロキシを作る問題です。
# Q1と違い、こちらはrespond_to_missing?がないとテストが失敗します。
#
class TryOver3::A2
  def initialize(name, value)
    instance_variable_set("@#{name}", value)
    self.class.attr_accessor name.to_sym unless respond_to? name.to_sym
  end
end

class TryOver3::A2Proxy
  def initialize(source)
    @source = source
  end

  def method_missing(name, *args)
    @source.send(name, *args)
  end

  def respond_to_missing?(name, include_all)
    @source.respond_to?(name, include_all)
  end
end

# Q3.
# Module#remove_methodを利用するとメソッドを削除できます。これを使い、
# 「boolean 以外が入っている場合には hoge? メソッドが存在しないようにする」を実現します。
# なお、メソッドを削除するメソッドはremove_methodの他にundef_methodも存在します。こちらでもテストはパスします。
# remove_methodとundef_methodの違いが気になる方はドキュメントを読んでみてください。
#
module TryOver3::OriginalAccessor2
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
        else
          mod.remove_method "#{attr_sym}?" if respond_to? "#{attr_sym}?"
        end
        @attr = value
      end
    end
  end
end


# Q4. 問題の解説
#
# const_missingを利用して、runners=で定義した定数を参照したときにrunメソッドを持つオブジェクトを返すことで
# 仕様を満たしています。回答例ではObject.newでオブジェクトを生成しましたが、runメソッドを持つオブジェクトであれば
# どんなクラスのインスタンスでもOKです。
#
class TryOver3::A4
  def self.const_missing(const)
    if @consts.include?(const)
      obj = Object.new
      obj.define_singleton_method(:run) { "run #{const}" }
      obj
    else
      super
    end
  end

  def self.runners=(consts)
    @consts = consts
  end
end

# Q5. 問題の解説
#
# これまで解いてきた問題の解法と、仕様を読み解く知識が問われる問題です。
# 2種類の書き方で同一の処理を行うが、そのうち1つは追加でdeprecation warningを出します。
# メソッドの実態はdefine_singleton_methodで定義し、もう1つはQ4と同様にconst_misisingを使い、
# runメソッド実行時にsendでもともとの定義を呼びだします。
#
# taskで定義されていないタスク名を定数として参照したときは既存のconst_missingの処理を継続させたいので
# superを実行しています。

module TryOver3::TaskHelper
  def self.included(klass)
    klass.define_singleton_method :task do |name, &task_block|
      define_singleton_method name do
        puts "start #{Time.now}"
        block_return = task_block.call
        puts "finish #{Time.now}"
        block_return
      end

      define_singleton_method(:const_missing) do |const|
        super(const) unless klass.respond_to?(const.downcase)

        obj = Object.new
        obj.define_singleton_method :run do
          warn "Warning: TryOver3::A5Task::#{const}.run is deprecated"
          klass.send name
        end
        obj
      end
    end
  end
end

class TryOver3::A5Task
  include TryOver3::TaskHelper

  task :foo do
    "foo"
  end
end
