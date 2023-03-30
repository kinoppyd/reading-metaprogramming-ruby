# Q1. 問題の解説
# e2オブジェクトの特異メソッドとしてhelloを定義する練習です。特異メソッドは対象のオブジェクトだけが利用可能なメソッドです。
#
class ExClass
end

e1 = ExClass.new
e2 = ExClass.new

def e2.hello
end

Judgement.call(e1, e2)

# Q2. 問題の解説
# Class.newでクラスを作る練習です。Class.newで作ったクラスは定数にアサインされるまで無名クラス(nameメソッドがnilを返す)になります。
#
e = Class.new(ExClass)
Judgement2.call(e)

# Q3. 問題の解説
# クラスマクロを作ってみる練習でした。クラスメソッドとしてmeta_attr_accessorを定義し、その中でゲッターとセッターを定義します。
#
class MetaClass
  class << self
    def meta_attr_accessor(name)
      meta_name = "meta_#{name}"
      attr_writer(meta_name)
      define_method(meta_name) do
        'meta ' + instance_variable_get("@#{meta_name}")
      end
    end
  end
end

# Q4. 問題の解説
# クラスインスタンス変数を使ってみる練習問題です。クラスメソッド用とインスタンスメソッド用のセッターゲッターを作り、
# それぞれで同じクラスインスタンス変数を参照するようにします。
#
class ExConfig
  class << self
    attr_accessor :config
  end

  def config
    self.class.instance_variable_get(:@config)
  end

  def config=(value)
    self.class.instance_variable_set(:@config, value)
  end
end

# Q5. 問題の解説
# アラウンドエイリアスの練習でした。この回答例ではprependを利用しています。
#
module Hook
  def hello
    before
    super
    after
  end
end

class ExOver
  prepend Hook
end

# Q6. 問題の解説
# class_evalを使う練習でした。ブロックを使うと、ブロックの外側のローカル変数にアクセスできます。
#
class MyGreeting
end

toplevellocal = 'hi'

MyGreeting.class_eval do
  define_method :say do
    toplevellocal
  end
end
