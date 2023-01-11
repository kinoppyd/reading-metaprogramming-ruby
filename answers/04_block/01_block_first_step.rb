#
# 1. MyMathクラスに、ブロックを実行した結果(数値)を2倍にして返すtwo_timesインスタンスメソッドを定義しましょう
#    実行例: MyMath.new.two_times { 2 } #=> 4

# 解説: yieldもしくはcallメソッドを使うメソッド実装の練習です。Railsでアプリケーションを書いているとそれほどブロックを取る
#      メソッドを書く機会はないのですが、素振りをしておいていざというときに使えるようにしておくと役に立つ時が来るかもしれません
class MyMath
  def two_times
    yield * 2
  end
end

# 2. AcceptBlockクラスにcallクラスメソッドが予め定義されており、このメソッドがブロックをとるとします。
#    実行例: AcceptBlock.call { 2 }
#    このメソッドを、下で用意されているMY_LAMBDAをブロック引数として渡して実行してみてください。
#    AcceptBlockクラスは問題側で用意している(テスト中に実装している)ため実装の必要はありません。

# 解説: Procオブジェクトをブロック引数として渡す練習です。実引数を渡すところで`&`を使うと、Procからブロックへの変換ができます。
MY_LAMBDA = -> { 3 }
AcceptBlock.call(&MY_LAMBDA)

# 3. MyBlockクラスにblock_to_procインスタンスメソッドを定義しましょう。block_to_procインスタンスメソッドはブロックを受け取り、
#    そのブロックをProcオブジェクトにしたものを返します

# 解説: 2と反対に、ブロックからProcオブジェクトの変換をする練習です。仮引数で&を使うとブロックからProcオブジェクトへの変換ができます。
class MyBlock
  def block_to_proc(&block)
    block
  end
end

# 4. MyClosureクラスにincrementインスタンスメソッドを定義しましょう。このincrementメソッドは次のように数値を1ずつインクリメントして返します
#    my = MyClosure.new
#    my.increment #=> 1
#    my.increment #=> 2
#    my.increment #=> 3
#    それに加えて、複数のインスタンスでカウンターを共有しているという特性があります。
#    my1 = MyClosure.new
#    my2 = MyClosure.new
#    my1.increment #=> 1
#    my2.increment #=> 2
#    my1.increment #=> 3
#    さらなる制限として、カウンターとして利用する変数はローカル変数を利用してください(これはテストにはないですが頑張ってローカル変数でテストを通るようにしてみてください)

# 解説: クロージャを実装してみる練習です。ブロックを利用するとスコープゲートなしで束縛を利用できるのでしたね。メソッド定義をdefではなく
#      define_method にすることで外側のローカル変数への参照を持ち続けることができます。
class MyClosure
  count = 0

  define_method :increment do
    count += 1
  end
end





