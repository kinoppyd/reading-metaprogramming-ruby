# 問題の解説
#
# ほぼ特筆するべきところがないですが、hoge?メソッドの実装は少し悩むかもしれません。
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

# 問題の解説
#
# 回答ではObjectクラスにhogeメソッドを定義しましたが、仕様としてあげられていた各クラス
# に対してそれぞれ個別にhogeメソッドを定義しても問題ありません。
class Object
  def hoge
    'hoge'
  end
end