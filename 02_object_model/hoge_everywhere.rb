# 次に挙げるクラスのいかなるインスタンスからも、hogeメソッドが呼び出せる
# それらのhogeメソッドは、全て"hoge"という文字列を返す
# - String
# - Integer
# - Numeric
# - Class
# - Hash
# - TrueClass

class Object
  def hoge
    "hoge"
  end
end

=begin
class String
  def hoge
    "hoge"
  end
end
class Integer
  def hoge
    "hoge"
  end
end
class Numeric
  def hoge
    "hoge"
  end
end
class Class
  def hoge
    "hoge"
  end
end
class Hash
  def hoge
    "hoge"
  end
end
class TrueClass
  def hoge
    "hoge"
  end
end
=end
