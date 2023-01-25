# 問題の解説
#
# respondクラスメソッドで定義したブロックを、askインスタンスメソッドからどうやって参照するか、というのが
# この問題の難所です。クラスメソッドで定義したインスタンス変数はクラスインスタンス変数としてクラスそのものに
# 紐づくインスタンス変数になるので、インスタンスメソッドから参照するには、回答例のように
# `self.class.instance_variable_get(インスタンス変数名)`のようにします。
# クラス変数を利用するとクラスメソッド、インスタンスメソッドどちらからでも`@@respond`のようにアクセスできるので
# 一見便利ですが、意図せず別のクラスとクラス変数が共有される可能性があるため、推奨しません。
#
# SimpleBotとそのサブクラスで利用イメージのように定義されたブロックは、settingsクラスメソッドにアクセスできます。
# settingsクラスメソッドは、settingクラスメソッドで登録したキーをメソッドとして使用でき、戻りとを登録した値にすると
# 仕様を満たせます。メソッドが定義できればどんなオブジェクトを返しても仕様を満たせるため、この回答例では
# 特異メソッドを定義したObjectインスタンスを返しています。必ずしもObjectインスタンスである必要はありません。
#
class SimpleBot
  class << self
    def respond(keyword, &block)
      @respond ||= {}
      @respond[keyword] = block
    end

    def setting(key, value)
      @settings ||= {}
      @settings[key] = value
    end

    def settings
      obj = Object.new

      @settings&.each do |key, value|
        obj.define_singleton_method(key) do
          value
        end
      end
      obj
    end
  end

  def ask(keyword)
    block = self.class.instance_variable_get(:@respond)[keyword]
    block.call if block
  end
end