# Q1. 問題の解説
#
# yieldもしくはcallメソッドを使うメソッド実装の練習です。Railsでアプリケーションを書いているとそれほどブロックを取る
# メソッドを書く機会はないのですが、素振りをしておいていざというときに使えるようにしておくと役に立つ時が来るかもしれません
class MyMath
  def two_times
    yield * 2
  end
end

# Q2. 問題の解説
#
# Procオブジェクトをブロック引数として渡す練習です。実引数を渡すところで`&`を使うと、Procからブロックへの変換ができます。
MY_LAMBDA = -> { 3 }
AcceptBlock.call(&MY_LAMBDA)

# Q3. 問題の解説
#
# Q2と反対に、ブロックからProcオブジェクトの変換をする練習です。仮引数で&を使うとブロックからProcオブジェクトへの変換ができます。
class MyBlock
  def block_to_proc(&block)
    block
  end
end


# Q4. 問題の解説
#
# クロージャを実装してみる練習です。ブロックを利用するとスコープゲートなしで束縛を利用できるのでしたね。メソッド定義をdefではなく
# define_method にすることで外側のローカル変数への参照を持ち続けることができます。
class MyClosure
  count = 0

  define_method :increment do
    count += 1
  end
end