module A3M1
  def self.hoge
    "hogehoge"
  end

  def self.fuga(n)
    "fuga" * n
  end
end

module FindBy
  def hoge_value
    { id: 1, name: "hoge" }
  end

  def fuga_value
    { id: 2, name: "fuga" }
  end
end
# NOTE: これより上の行は変更しないこと

# Q3.
# 次の動作をする A3 class を実装する
# - "hogehoge"を返す、hogeメソッドとなること
# - "fugafugafuga"を返す、fugaメソッドとなること
# - A3クラスに上記のメソッドを定義しないこと
class A3
end

# Q4
# 次の動作をする A4 class を実装する
# - コンストラクタで与えた文字列を逆にするreverseメソッドを実装してください
# - この時に表示する結果は、"metaprogramming ruby の逆は ybur gnimmargorpatem" を期待しています
# - コンストラクタで与えるものが、文字以外の場合、"SmartHR Tech Team" を期待しています
class A4
end

# Q5
# 次の動作をする A5 class を実装する
# - { id: 1, name: "hoge" }を返す、find_by_hogeメソッド
# - { id: 2, name: "fuga" }を返す、find_by_fugaメソッド
# - [{ id: 1, name: "hoge" }, { id: 2, name: "fuga" }]を返す、find_by_hoge_and_fugaメソッド
# - idに応じた内容を返す、find_by_idメソッド
#   - 例えば、引数が1の場合は、 { id: 1, name: "hoge" }を返す
#   - 例えば、引数が2の場合は、 { id: 2, name: "fuga" }を返す
# - 上記以外のfind_by_*メソッドの中にはhogeとfugaが存在しない場合もあるので、混在している場合はhogeとfugaのみが入ったArrayを返す
#   - 例えば、find_by_hoge_and_yogaの場合は、[{ id: 1, name: "hoge" }]を返す
#   - 例えば、find_by_yoga_and_fugaの場合は、[{ id: 1, name: "fuga" }]を返す
# - 上記以外のfind_by_*メソッドはnilを返す
# - OR条件は考慮せず、find_by_xxx_and_xxxの形式でだけ考慮で構わない
class A5
  include FindBy
end
