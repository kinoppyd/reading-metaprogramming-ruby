# Object Model

## Overview of p11-p28

## オープンクラス
### 概要
Rubyではclassを再オープンして、メソッド定義などを追加することができる。これをオープンクラスと呼ぶ

例えば下記のように、標準ライブラリの Numeric クラスに独自のメソッドを追加することができる

```ruby
class Numeric
  def to_money(currency = nil)
    Monetize.from_numeric(self, currency || Money.default_currency)
  end
end
```

### 問題点
オープンクラスで、既存のメソッドと同名のメソッドを定義してしまうと、既存のメソッドを上書きできてしまう。

そのため安易に使うべきではなく、モンキーパッチという蔑称で呼ばれることもある

## オブジェクトモデル
### インスタンス変数
Rubyのインスタンス変数は値が代入された時に初めて出現する。

そのため同じクラスのオブジェクトでも、インスタンス変数の数が異なることがある。

```ruby
irb(main):001:0> class A
irb(main):002:1>   def set_hoge
irb(main):003:2>     @hoge = 'hoge'
irb(main):004:2>   end
irb(main):005:1> end
=> :set_hoge
irb(main):006:0> a = A.new
=> #<A:0x00007fc3f12712f0>

# 最初はインスタンス変数は空
irb(main):007:0> a.instance_variables
=> []

# メソッド呼び出しで値を代入すると現れる
irb(main):008:0> a.set_hoge
=> "hoge"
irb(main):009:0> a.instance_variables
=> [:@hoge]
```

### メソッド
インスタンス変数と違い、共通のクラスを持つオブジェクトは、メソッドも共通している

メソッドはオブジェクトではなく、クラスに存在している

### Classクラス
Rubyではクラスもオブジェクトであり、各種クラスは、Classクラスのインスタンスである

```ruby
irb(main):011:0> 'hoge'.class
=> String
irb(main):012:0> 'hoge'.class.class
=> Class
```

なお、ClassクラスのスーパークラスはModuleであり、すべてのクラスはモジュールである。

### 定数
Rubyにおいて、定数はファイルシステムのようにツリー状に配置されている。

モジュールやクラスで囲えばネストされるし、::を繋げることで単独でネストと同じように書くことができる

```ruby
irb(main):001:0> module A
irb(main):002:1>   class B
irb(main):003:2>     C = 'c'
irb(main):004:2>   end
irb(main):005:1> end
=> "c"

# CはAとBでネストされている
irb(main):006:0> A::B::C
=> "c"

# コロン二つを繋げて書くことでネストさせたのと同じようにかける
irb(main):007:0> A::B::D = 'd'
=> "d"
irb(main):008:0> A::B::D
=> "d"
```

### まとめ
- すべてのクラスはClassクラスのインスタンス
- ClassクラスのスーパークラスはModule
- ModuleのスーパークラスはObject
- ObjectはClassクラスのインスタンス
