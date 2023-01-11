# Q1. 問題の解説
#
# ほぼ特筆するべきところがないですが、hoge?メソッドの実装は少し悩むかもしれません。
# 自身を参照するにはselfを使います。
#
class Hoge < String
  Hoge = 'hoge'

  def hogehoge
    'hoge'
  end

  def hoge?
    self == 'hoge'
  end
end

# Q2. 問題の解説
#
# 回答例ではObjectクラスにhogeメソッドを定義しました。仕様としてあげられているクラスはすべて
# Objectクラスのサブクラスなので、Objectクラスのインスタンスメソッドとしてhogeを定義すると仕様を満たせます。
# Objectクラスではなく、仕様としてあげられていた各クラス(String, Integer, Numeric, Class, Hash, TrueClass)
# に対してそれぞれ個別にhogeメソッドを定義しても問題ありません。
class Object
  def hoge
    'hoge'
  end
end