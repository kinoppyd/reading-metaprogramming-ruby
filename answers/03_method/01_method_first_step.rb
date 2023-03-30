# Q1. 問題の解説
#
# define_methodとdefine_singleton_methodとmethod_missingの素振り用の問題です。
# define_singleton_methodは3章にはまだ出てきていませんが、これを知らないと3章の問題を解くのが難しくなるので覚えておいてください
# respond_to_missing?は、respond_to?メソッド実行時にメソッドが定義されていない場合に呼ばれるメソッドです。method_missingを定義する場合は
# 必ず定義しておきましょう。
#
class F1
  define_method :hello do
    'hello'
  end

  define_singleton_method :world do
    'world'
  end

  def method_missing(*args)
    'NoMethodError'
  end

  def respond_to_missing?(*args)
    true
  end
end

# Q2. 問題の解説
#
# メソッドを実行したら新しいメソッドができる、ということを実感してもらうための問題です。この回答のようなdefがネストする実装は普通はやりませんが、
# 「特定の処理を実行する時に動的にメソッドを生やす」という場面は、メタプロをしていればそれなりにあります。
#
class F2
  def add_hi
    def hi
    end
  end
end