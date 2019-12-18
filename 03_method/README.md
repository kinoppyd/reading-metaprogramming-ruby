# Method

## Overview of 3 - 3.2.4

### 重複問題

下のような、データソースからコンピュータのコンポーネントの情報・価格を取得できるクラスがある。ここから、$100以上のコンポーネントを発見する為、レポート出力機能を作成することにする。

```ruby
class DS
  def initialize # データソースに接続
  def get_cpu_info(workstation_id) #...
  def get_cpu_price(workstation_id) #...
  def get_mouse_info(workstation_id) #...
  def get_mouse_price(workstation_id) #...
  # 以下、get_*_infoとget_*_priceの繰り返し
```

ナイーブな実装をすると、下記のように重複の多いプログラムになる。

```ruby
class Computer
  def initialize(computer_id, data_source)
    @id = computer_id
    @data_source = data_source
  end

  def mouse
    info = @data_source.get_mouse_info(@id)
    price = @data_source.get_mouse_price(@id)
    result = "Mouse: #{info} ($#{price})"
    return "* #{result}" if price >= 100
    result
  end

  def cpu
    info = @data_source.get_cpu_info(@id)
    price = @data_source.get_cpu_price(@id)
    result = "Cpu: #{info} ($#{price})"
    return "* #{result}" if price >= 100
    result
  end

  #...
end
```

これを解決するためには、

* 動的メソッド
* method_missing

の二つの解決法がある。

### 動的ディスパッチ

メソッドを呼び出す場合、通常はドット記法を使用するが、`Object#send`を使用することもできる。

```ruby
class MyClass
  def my_method(my_arg)
    my_arg * 2
  end
end

obj = MyClass.new
obj.my_method(3) # => 6
obj.send(:my_method, 3) # => 6
```

`send`の第一引数は、メソッド名である。メソッド名には文字列・シンボルが使用できる。その他の引数はそのまま対象のメソッドに渡される。

`send`を使用することで、呼び出したいメソッド名が通常の引数になり、実行時に呼び出すメソッドを決定できる。これを**動的ディスパッチ**と呼ぶ。

#### Pryの例
Pryでは、インタプリタの設定をアトリビュートとして保存しており、下記のように呼び出せる。

```ruby
pry.refresh(:memory_size => 99, :quiet => false)
pry.memory_size   # => 99
pry.quiet         # => false
```

Pryでは、この[refreshメソッド](https://github.com/pry/pry/blob/v0.9.12.6/lib/pry/pry_instance.rb#L95)を下記のように実装している。

```ruby
def refresh(options={})
  defaults   = {}
  attributes = [
                  :input, :output, :commands, :print, :quiet,
                  :exception_handler, :hooks, :custom_completions,
                  :prompt, :memory_size, :extra_sticky_locals
                ]

  attributes.each do |attribute|
    defaults[attribute] = Pry.send attribute
  end

  defaults[:input_stack] = Pry.input_stack.dup

  defaults.merge!(options).each do |key, value|
    send("#{key}=", value) if respond_to?("#{key}=")
  end

  true
end
```

まず`send`を使用してデフォルト値を読み込み、次の`send`で`memory_size=`などのアクセサを呼び出している。

#### privateメソッド
`Object#send`メソッドは、privateメソッドを呼び出すことができる。privateメソッドを呼び出せない`public_send`というメソッドもあるが、実用上問題になることはほとんどない。`send`はprivateメソッドを呼び出せるために利用されることが多い。

### 動的メソッド
`Module#define_method`にメソッド名とブロックを渡すと、指定したメソッド名でブロックが本体となるようなメソッドを定義できる。

```ruby
class MyClass
  define_method :my_method do |my_arg|
    my_arg * 3
  end
end

obj = MyClass.new
obj.my_method(2) # => 6
```

`define_method`は`MyClass`の中で実行されているため、`MyClass`のインスタンスメソッドとなる。実行時にメソッドを定義するこの手法を**動的メソッド**と呼ぶ。これにより、実行時にメソッド名を決定することができる。

### 動的ディスパッチを使用したリファクタリング

冒頭の`Computer`クラスを、動的ディスパッチを使用して下記のようにリファクタリングできる。

```ruby
class Computer
  def initialize(computer_id, data_source)
    @id = computer_id
    @data_source = data_source
  end

  def mouse
    component :mouse
  end

  def cpu
    component :cpu
  end
  
  def keyboard
    component :keyboard
  end

  def component(name)
    info = @data_source.send "get_#{name}_info", @id
    price = @data_source.send "get_#{name}_price", @id
    result = "#{name.capitalize}: #{info} ($#{price})"
    return "* #{result}" if price >= 100
    result
  end
end
```

`component`の引数に指定された`name`を利用して、`@data_source.send "get_#{name}_info", @id`のようにメソッドを呼び出している。

また、`name.capitalize`を用いてコンポーネント名を大文字にしている。

このコードで重複を大きく取り除けるが、各コンポーネントごとの定義を書く必要がある。これを回避するため、`define_method`を使用する。

### 動的メソッドを使用したリファクタリング
```ruby
class Computer
  def initialize(computer_id, data_source)
    @id = computer_id
    @data_source = data_source
  end

  def self.define_component(name)
    define_method(name) do
      info = @data_source.send "get_#{name}_info", @id
      price = @data_source.send "get_#{name}_price", @id
      result = "#{name.capitalize}: #{info} ($#{price})"
      return "* #{result}" if price >= 100
      result
    end
  end

  define_component :mouse
  define_component :cpu
  define_component :keyboard
end
```

`Computer`クラスの中で、`define_component`は3回呼び出されている。Computerクラスに対して`define_method`を呼び出したいので、`define_component`はクラスメソッドにする必要がある。

これにより、メソッド定義の重複は取り除けるが、define_componentに指定する名前を全て列挙する必要がある。

### イントロスペクション

`DS`の`methods`に対して正規表現で目的のメソッドを取り出すことで、コンポーネントの列挙を回避できる。

```ruby
class Computer
  def initialize(computer_id, data_source)
    @id = computer_id
    @data_source = data_source
    data_source.methods.grep(/^get_(.*)_info$/) { Computer.define_component $1 }
  end

  def self.define_component(name)
    define_method(name) do
      info = @data_source.send "get_#{name}_info", @id
      price = @data_source.send "get_#{name}_price", @id
      result = "#{name.capitalize}: #{info} ($#{price})"
      return "* #{result}" if price >= 100
      result
    end
  end
end
```

ここでは、`Array#grep`と正規表現を活用して、`methods`から`get_****_info`のようなメソッド名を全て抽出し、それをコンポーネント名として`define_component`を呼び出している。

`data_source`に

- `get_cpu_info`
- `get_mouse_info`
- `get_keyboard_info`

のようなメソッドがあれば、cpu・mouse・keyboardに対してそれぞれ`Computer.define_method`が呼び出される。

これにより、`DS`クラスで定義されているコンポーネントを明示的に指定する必要がなくなる。`DS`クラスに新しいメソッドが追加された場合でも、上記のコードであれば`grep`によって自動的に`Computer`クラスにメソッドが追加される。

### まとめ
* `Object#send`を使用することで、呼び出したいメソッド名を実行時に決定できる。これを**動的ディスパッチ**という。
* `Module#define_method`を使用することで、メソッドを実行時に定義することができる。これを**動的メソッド**という。
* 動的ディスパッチや動的メソッドによって、メソッドの呼び出し・定義における重複を取り除くことができる。
* `Object#methods`等を使用することで、あるオブジェクトに対するラッパーを書く場合などに、対応するメソッドを動的に定義することができる。


## 正誤表

### 3.2.4

```diff
-define_methodが3回呼び出されていることに注目してほしい。
+define_componentが3回呼び出されていることに注目してほしい。
```

```diff
-Computerクラスに対してdefine_componentを呼び出したいので、define_methodはクラスメソッドにする必要がある。
+Computerクラスに対してdefine_methodを呼び出したいので、define_componentはクラスメソッドにする必要がある。
```