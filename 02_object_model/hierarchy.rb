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


# Q1.
# 次の動作をする C1 class を実装する
# - C1.ancestors.first(2) が [C1, M1] となる
# - C1.new.name が 'C1' を返す
class C1
  include M1

  def name
    'C1'
  end
end


# Q2.
# 次の動作をする C2 class を実装する
# - C2.ancestors.first(2) が [M1, C2] となる
# - C2.new.name が 'M1' を返す
class C2
  prepend M1

  def name
    'C2'
  end
end


# Q3.
# 次の動作をする C3 class, MySuperClass class を実装する
# - C3.ancestors.first(6) が [M1, C3, M2, M3, MySuperClass, M4] となる
# - C3.new.name が 'M1' を返す
class MySuperClass
  include M4
end

class C3 < MySuperClass
  include M3
  include M2
  prepend M1

  def name
    'C3'
  end
end


# Q4.
# 次の動作をする C4 class のメソッド increment を実装する
# - increment メソッドを呼ぶと value が +1 される
# - また、increment メソッドは value を文字列にしたものを返す
#   c4 = C4.new
#   c4.increment # => "1"
#   c4.increment # => "2"
#   c4.increment # => "3"
# - 定義済みのメソッド (value, value=) は private のままとなっている
class C4
  def initialize
    self.value = 0
  end

  def increment
    (self.value += 1).to_s
  end

  private

  attr_accessor :value
end

# Q5.
# 次の動作をする M1Refinements module を実装する
# - M1Refinements は M1 の name インスタンスメソッドをリファインし,
#   リファインされた name メソッドは "Refined M1" を返す
# - C5.new.another_name が文字列 "M1" を返す
# - C5.new.other_name が文字列 "Refined M1" を返す
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

# Q6.
# 次の動作をする C6 class を実装する
# - M1Refinements は Q5 で実装したものをそのまま使う
# - C6.new.name が 'Refined M1' を返すように C6 に name メソッドを実装する
class C6
  include M1
  using M1Refinements

  def name
    super
  end
end
