# 問題の解説
#
# 仕様の「邪悪な機能」をクロージャを使って実装することに気付けるかどうかを問う問題です。
# initializeメソッドの中でdefine_singleton_methodを利用してsend_mailメソッドを定義することで、
# initializeメソッドのローカル変数として第2引数を扱います。こうすることで、
# send_mailメソッドの中でしか参照できない変数ができあがります。

class EvilMailbox
  def initialize(obj, str = nil)
    @obj = obj
    @obj.auth(str) if str

    define_singleton_method(:send_mail) do |to, body, &block|
      result = obj.send_mail(to, body + str.to_s)
      block.call(result) if block
      nil
    end
  end

  def receive_mail
    obj.receive_mail
  end

  private

  attr_reader :obj
end