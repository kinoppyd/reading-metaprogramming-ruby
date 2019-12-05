# 次に挙げるクラスのいかなるインスタンスからも、hogeメソッドが呼び出せる
# それらのhogeメソッドは、全て"hoge"という文字列を返す
# - String
# - Integer
# - Number
# - Class
# - Hash
# - TrueClass

class Object
  def hoge
    "hoge"
  end
end