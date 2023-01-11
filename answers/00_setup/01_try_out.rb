# 問題の解説
#
# ミドルネームが渡されないことがある、というのをどう扱うかがこの問題のポイントです。
# `def initialize(first_name, middle_name = nil, last_name)`のようにメソッドを定義することで
# 簡潔に仕様を満たすことができます。
# あとはスペースで各要素を区切るやり方としてArray#joinを使っているのもポイントです。
# これ以外にも複数の解法があります。この回答通りになっていなくても問題ありません。
class TryOut
  attr_writer :first_name

  def initialize(first_name, middle_name = nil, last_name)
    @first_name = first_name
    @middle_name = middle_name
    @last_name = last_name
  end

  def full_name
    [@first_name, @middle_name, @last_name].compact.join(' ')
  end

  def upcase_full_name
    full_name.upcase
  end

  def upcase_full_name!
    @first_name.upcase!
    @middle_name&.upcase!
    @last_name.upcase!
    full_name
  end
end