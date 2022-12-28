# 1. ExClassクラスのオブジェクトが2つあります。これらをJudgement.callに渡しています。
#    Judement.callはテスト側で定義するので実装は不要です。この状況でe2オブジェクト"だけ"helloメソッドを
#    使えるようにしてください。helloメソッドの中身は何でも良いです。
#
# 解説: e2オブジェクトの特異メソッドとしてhelloを定義する練習です。特異メソッドは対象のオブジェクトだけが利用可能なメソッドです。
#
class ExClass
end

e1 = ExClass.new
e2 = ExClass.new

def e2.hello
end

Judgement.call(e1, e2)

# 2. ExClassを継承したクラスを作成してください。ただし、そのクラスは定数がない無名のクラスだとします。
#    その無名クラスをそのままJudgement2.call の引数として渡してください(Judgement2.callはテスト側で定義するので実装は不要です)
# 解説: Class.newでクラスを作る練習です。Class.newで作ったクラスは定数にアサインされるまで無名クラス(nameメソッドがnilを返す)になります。

e = Class.new(ExClass)
Judgement2.call(e)

# 3. 下のMetaClassに対し、次のように`meta_`というプレフィックスが属性名に自動でつき、ゲッターの戻り値の文字列にも'meta 'が自動でつく
#    attr_accessorのようなメソッドであるmeta_attr_accessorを作ってください。セッターに文字列以外の引数がくることは考えないとします。
#
#    使用例:
#
#    class MetaClass
#      # meta_attr_accessor自体の定義は省略
#      meta_attr_accessor :hello
#    end
#    meta = MetaClass.new
#    meta.meta_hello = 'world'
#    meta.meta_hello #=> 'meta world'
#
# 解説: クラスマクロを作ってみる練習でした。クラスメソッドとしてmeta_attr_accessorを定義し、その中でゲッターとセッターを定義します。
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

# 4. 次のようなExConfigクラスを作成してください。ただし、グローバル変数、クラス変数は使わないものとします。
#    使用例:
#    ExConfig.config = 'hello'
#    ExConfig.config #=> 'hello'
#    ex = ExConfig.new
#    ex.config #=> 'hello'
#    ex.config = 'world'
#    ExConfig.config #=> 'world'

# 解説: クラスインスタンス変数を使ってみる練習問題です。クラスメソッド用とインスタンスメソッド用のセッターゲッターを作り、
# それぞれで同じクラスインスタンス変数を参照するようにします。

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

# 5.
# ExOver#helloというメソッドが定義されています。ExOver#helloメソッドを実行したとき、
# helloメソッドの前にExOver#before、helloメソッドの後にExOver#afterを実行させるようにしましょう。
# ExOver#hello, ExOver#before, ExOver#afterの実装自体ははそれぞれテスト側で定義しているので実装不要(変更不可)です。
#
# 解説: アラウンドエイリアスの練習でした。この回答例ではprependを利用しています。

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

# 6. 次の toplevellocal ローカル変数の中身を返す MyGreeting#say を実装してみてください。
#    ただし、下のMyGreetingは編集しないものとします。toplevellocal ローカル変数の定義の下だけ編集してください。
#    ヒント: スコープゲートを乗り越える方法について書籍にありましたね
#
# 解説: class_evalを使う練習でした。ブロックを使うと、ブロックの外側のローカル変数にアクセスできます。

class MyGreeting
end

toplevellocal = 'hi'

MyGreeting.class_eval do
  define_method :say do
    toplevellocal
  end
end


