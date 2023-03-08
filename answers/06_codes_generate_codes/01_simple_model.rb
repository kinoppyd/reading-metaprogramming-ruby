# 問題の解説
#
# includeされたクラスのattr_accessorメソッドの挙動を変更するために、まずincludedフックメソッドを利用します。
#
# 初期値を管理する`_histories`と`_initial`属性をattr_accessorで用意しておきます。
# historiesやinitialといった名前はクラスのメソッド定義などと衝突する可能性が高いので、`_`を先頭につけて回避するようにしています。
# `_histories`は、writerメソッドを呼び出した時に、その値を記憶するためのハッシュです。キーは属性名、値はその属性に対する書き込み履歴の配列です。
# `_initial`は、初期値を記憶するためのハッシュです。キーは属性名、値はその属性の初期値です。
#
# includedの中で対象のクラスをextendして、クラスメソッドであるattr_accessorメソッドを再定義します。
# readerメソッドは通常通りの動作を行う、と仕様にあるのでattr_readerを呼び出しています。
# writerメソッドは、通常に加え以下の動作を行うと仕様にあるので、独自に定義します。writerメソッドの中で、`_histories`に書き込み履歴を追記させています。
# そのうえで、instance_variable_setで属性の値を書き換えています。
#
# initializeメソッドを定義し、`_initial`と`_histories`の初期化と`_initial`への初期値の記憶を行っています。
# 残りの`restore`, `changed?`, `ATTR_changed?`メソッドは、`_initial`と`_histories`を活用することで問題なく実装できるはずです。
#
module SimpleModel
  def self.included(klass)
    klass.attr_accessor :_histories, :_initial
    klass.extend(ClassMethods)
  end

  def initialize(args = {})
    self._initial = args
    self._histories = {}
    args.each do |key, value|
      instance_variable_set("@#{key}", value)
    end
  end

  def restore!
    self._histories = {}
    _initial.each do |key, value|
      instance_variable_set("@#{key}", value)
    end
  end

  def changed?
    !_histories.empty?
  end

  module ClassMethods
    def attr_accessor(*syms)
      syms.each { |sym| attr_reader sym }
      syms.each do |sym|
        define_method "#{sym}=" do |value|
          (_histories[sym] ||= []).push(value)
          instance_variable_set("@#{sym}", value)
        end

        define_method "#{sym}_changed?" do
          !!_histories[sym]
        end
      end
    end
  end
end
