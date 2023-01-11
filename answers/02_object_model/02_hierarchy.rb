module M1
  def name
    'M1'
  end
end

module M2
  def name
    'M2'
  end
end

module M3
  def name
    'M3'
  end
end

module M4
  def name
    'M4'
  end
end

# NOTE: これより上の行は変更しないこと


# Q1. 問題の解説
#
# M1をC1にincludeすると、継承ツリーはC1の次にM1が位置することになり、仕様を満たせます。
#
class C1
  include M1

  def name
    'C1'
  end
end


# Q2. 問題の解説
#
# M2をC2にprependすると、継承ツリーはM2の次にC2が位置することになり、仕様を満たせます。
#
class C2
  prepend M1

  def name
    'C2'
  end
end


# Q3. 問題の解説
#
# モジュールを複数includeしたり、スーパークラスを明示的に定義したときの
# 継承ツリーがどうなるかの理解を問う問題です
#
class MySuperClass
  include M4
end

class C3 < MySuperClass
  prepend M1
  include M3
  include M2

  def name
    'C3'
  end
end


# Q4. 問題の解説
#
# privateメソッドとして定義していると、レシーバを明示的に指定したメソッド呼び出しができません。
# しかしこれには例外があり、レシーバがselfであれば問題ありません。
# この仕様はRuby2.7からのものであり、2.7未満はセッターメソッド(=が末尾についているもの)のみがselfをつけて呼び出し可能でした。
# メソッド形式を使わず@valueのようにインスタンス変数を直接扱ってもテストは通るので、それでもOKです。
class C4
  def increment
    self.value ||= 0
    self.value += 1
    value.to_s
  end
  private

  attr_accessor :value
end

# Q5. 問題の解説
#
# refinementsの練習問題です。
# refineしたメソッドの影響範囲はusingがクラス内であれば、そのusingしたクラス内でのみ、かつusing以降の行です。
module M1Refinements
  refine M1 do
    def name
      'Refined M1'
    end
  end
end

class C5
  include M1

  def another_name
    name
  end

  using M1Refinements

  def other_name
    name
  end
end


# Q6. 問題の解説
#
# Q5の解説でも書いたように、refineしたメソッドの影響範囲はusingがクラス内であれば、そのusingしたクラス内でのみ、かつusing以降の行です。
# なので、問題として用意したコードのままだとなにもrefineされず、もともとのC6#nameは'M1'を返します。
# using以降の行でM1#nameを呼び出すC6#nameを定義するとrefineした実装が呼び出されます。
#
class C6
  include M1
  using M1Refinements

  def name
    super
  end
end