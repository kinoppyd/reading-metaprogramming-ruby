# Q1.
# Hogeクラスは次の仕様を持つ
# HogeクラスのスーパークラスはStringである
class Hoge < String
  # "hoge" という文字列の定数Hogeを持つ
  Hoge = "hoge"

  # "hoge" という文字列を返すhogehogeメソッドを持つ
  def hogehoge
    "hoge"
  end

  # 自身が"hoge"という文字列である時（HogeクラスはStringがスーパークラスなので、当然自身は文字列である）、trueを返すhoge?メソッドが定義されている
  def hoge?
    self == "hoge"
  end
end

# Q2.
# 次に挙げるクラスのいかなるインスタンスからも、hogeメソッドが呼び出せるようにする
# それらのhogeメソッドは、全て"hoge"という文字列を返す
# - String
class String
  def hoge
    "hoge"
  end
end
# - Integer
class Integer
  def hoge
    "hoge"
  end
end
# - Numeric
class Numeric
  def hoge
    "hoge"
  end
end
# - Class
class Class
  def hoge
    "hoge"
  end
end
# - Hash
class Hash
  def hoge
    "hoge"
  end
end
# - TrueClass
class TrueClass
  def hoge
    "hoge"
  end
end
