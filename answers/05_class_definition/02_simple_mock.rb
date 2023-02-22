# 問題の解説
# まずmockメソッドの実装から考えます。「もとのオブジェクトの能力が失われてはいけない」という仕様から、引数として受け付けたオブジェクトに
# SimpleMockをextendすることでモック化に必要なメソッドであるexpects, watch, called_timesを追加するようにします。
#
# expectsメソッドを実行したとき、レシーバとなるオブジェクトにだけメソッドを追加したいのでdefine_singleton_methodを利用して動的にメソッドを追加します。
# メソッドの内容は、次のようにexpectsメソッドに続けてwatchメソッドが実行されたときに備えて、
# カウンター用のインスタンス変数`@counter`(キーがexpectsで指定されたメソッド名、値が実行回数のハッシュ)を用意して
# watchが実行されていたら(つまり対応する`@counter`の値があれば)それをインクリメントするようにします。
#
# ```ruby
# obj = Object.new
# obj = SimpleMock(obj)
# obj.expects(:hoge, true)
# obj.watch(:hoge)
# obj.hoge #=> true
# ````
#
# また、watchを実行したときにexpects経由で定義したメソッドを上書きしないように、expectsしたメソッド名を`@expects`に配列として保存しておきます。
# watchでは`@expects`を見て、すでにexpectsで定義済みであればメソッドを上書きしないようにします。
# そうしないとwatchメソッドを実行したときに、モックメソッドの戻り値の情報が失われてしまいます。
#
# 次にnewメソッドの実装を考えます。仕様から、SimpleMockはモジュールであることを求められていますが、
# 同時にモジュールには存在しないnewメソッドを持つようにも求められています。
# これを、クラスメソッドのnewを明示的に定義することで満たします。このとき何らかのオブジェクトをmockメソッドの引数にして、
# 戻り値を返すようにすれば要件は満たせますが、モック用のオブジェクトとしては余計なメソッドをなるべく持たない方が扱いやすいので、
# Object.newをmockメソッドの引数にしています。
#
module SimpleMock
  def self.mock(obj)
    obj.extend(SimpleMock)
    obj
  end

  def self.new
    obj = Object.new
    mock(obj)
  end

  def expects(name, value)
    define_singleton_method(name) do
      @counter[name] += 1 if @counter&.key?(name)
      value
    end
    @expects ||= []
    @expects.push(name.to_sym)
  end

  def watch(name)
    (@counter ||= {})[name] = 0

    return if @expects&.include?(name.to_sym)

    define_singleton_method(name) do
      @counter[name] += 1
    end
  end

  def called_times(name)
    @counter[name]
  end
end
