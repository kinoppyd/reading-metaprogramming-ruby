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

## Overview of p29-p45

## メソッド探索
Ruby がレシーバのクラスに入り、メソッドを見つけるまで継承チェーンを上ることをメソッド探索と呼ぶ。

例えば下記のように、レシーバである MySubClass のスーパークラスを辿っていくことで、 `my_method` を探し出すことが出来る。

```ruby
class MyClass
  def my_method; 'my_method()'; end
end 

class MySubClass < MyClass
end

obj = MySubClass.new
obj.my_method() # => "my_method()"
```

継承チェーンとは BasicObject までのクラスの継承関係の軌跡のことで、Module#ancestors で参照することができる。

```ruby
MySubClass.ancestors # => => [MySubClass, MyClass, Object, Kernel, BasicObject]
```

### モジュールとメソッド探索
Ruby はモジュールを継承チェーンに挿入する。モジュールは2通りの挿入方法があり、1つはインクルード、2つめはプリペンドだ。

インクルードはクラスの真上にモジュールを挿入し、プリペンドはクラスの真下にモジュールを挿入する。

```ruby
module M1
  def my_method
    'M1#my_method()'
  end
end

class C
  include M1
end

class D < C; end

D.ancestors # => [D, C, M1, Object, Kernel, BasicObject]

class C2
  prepend M1
end

class D2 < C2; end

D2.ancestors # => [D2, M1, C2, Object, Kernel, BasicObject]
```

### 多重インクルード
あるモジュールが既に継承チェーンに含まれているとき、2回目以降の挿入は無視される。

下記の例では、M1 は既に M3 の継承チェーンに含まれているため、 M2 でインクルードされている M1 は無視される。

```ruby
module M1; end

module M2
  include M1
end

module M3
  prepend M1
  include M2
end

M3.ancestors # => [M1, M3, M2]
```

### Kernel
Object クラスが Kernel モジュールをインクルードしているため、Kernel モジュールのメソッドはどこからでも呼び出すことが出来る。

下記から分かるように、print は Kernelの private インスタンスメソッドであるため、どこからでも呼び出せる。
```ruby
Kernel.private_instance_methods.grep(/^pr/) # => [:proc, :printf, :print]
```

## メソッドの実行
### self キーワード
メソッドを呼び出すとき、メソッドのレシーバが self になる。

全てのインスタンス変数は self のインスタンス変数になり、レシーバを明示しないメソッド呼び出しは全て self に対する呼び出しとなる。

```ruby
class MyClass
  def testing_self
    @var = 10
    my_method
    self
  end

  def my_method
    @var = @var + 1
  end
end

obj = MyClass.new
obj.testing_self # => #<MyClass:0x00007feae89f4dd8 @var=11>
```

### self の特殊ケース
- トップレベル
  - メソッドを呼び出さないとき、self は Ruby のインプリンタが作った main 内部にいる。
  - このオブジェクトはトップレベルコンテキストと呼ばれる。
- クラス定義と self
    - クラスやモジュールの定義の内側では、self の役割はクラスやモジュールそのものになる。

### private の本当の意味
- Ruby では「private ルール」が定義されている。
  - ルール1: 自分以外のオブジェクトのメソッドを呼び出すには、レシーバを明示的に指定する必要がある
  - ルール2: private のついたメソッドを呼び出すときはレシーバを指定できない

以下の例では、ルール2 を破っているためエラーとなる。
```ruby
class C
  def public_method
    self.private_method
  end

  private

  def private_method; end
end

C.new.public_method 
# => NoMethodError (private method `private_method' called for #<C:0x00007feae8a3c7a0>)
```

### Refinements
クラスを再定義して拡張する機能として Refinements がある。
Refinements はモンキーパッチと似ているが、影響範囲が特定のスコープに限定される点で異なる。

以下の例では、refine ブロック内で拡張された reverse メソッドを、using メソッドを使うことで有効にしている。
```ruby
module StringExtensions
  refine String do
    def reverse
      "esrever"
    end
  end
end

module StringStuff
  using StringExtensions
  "my_string".reverse # => "esrever"
end

"my_string".reverse # => "gnirts_ym"
```

Refinements は現在も進化を続けている機能であるため、ベストプラクティスは確立されていないようです。

### まとめ
- クラスはそれぞれ BasicObject まで続く継承チェーンを持っている。
- クラスにモジュールをインクルード（プリペンド）すると、そのクラスの継承チェーンの真上（真下）にモジュールが挿入される。
- メソッドを呼び出すと、レシーバが self になる。
- モジュール（あるいはクラス）を定義すると、そのモジュールが self になる。
- インスタンス変数は常に self のインスタンス変数と見なされる。
- レシーバを明示的に指定せずにメソッドを呼び出すと、self のメソッドだと見なされる。
- Refinements は using を呼び出したところから、ファイルやモジュールの定義が終わるところまでの限られた部分でのみ有効になる。
