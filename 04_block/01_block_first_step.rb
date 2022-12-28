#
# 1. MyMathクラスに、ブロックを実行した結果(数値)を2倍にして返すtwo_timesインスタンスメソッドを定義しましょう
#    実行例: MyMath.new.two_times { 2 } #=> 4

class MyMath
end

# 2. AcceptBlockクラスにcallクラスメソッドが予め定義されており、このメソッドがブロックをとるとします。
#    実行例: AcceptBlock.call { 2 }
#    このメソッドを、下で用意されているMY_LAMBDAをブロック引数として渡して実行してみてください。
#    AcceptBlockクラスは問題側で用意している(テスト中に実装している)ため実装の必要はありません。

MY_LAMBDA = -> { 3 }

# 3. MyBlockクラスにblock_to_procインスタンスメソッドを定義しましょう。block_to_procインスタンスメソッドはブロックを受け取り、
#    そのブロックをProcオブジェクトにしたものを返します

class MyBlock
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

class MyClosure
end





