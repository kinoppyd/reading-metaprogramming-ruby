require 'forwardable'
class TryOut
  # このクラスの仕様
  # コンストラクタは、2つまたは3つの引数を受け付ける。引数はそれぞれ、ファーストネーム、ミドルネーム、ラストネームの順で、ミドルネームは省略が可能。
  # full_nameメソッドを持つ。これは、ファーストネーム、ミドルネーム、ラストネームを半角スペース1つで結合した文字列を返す。ただし、ミドルネームが省略されている場合に、ファーストネームとラストネームの間には1つのスペースしか置かない
  # first_name=メソッドを持つ。これは、引数の内容でファーストネームを書き換える。
  # upcase_full_nameメソッドを持つ。これは、full_nameメソッドの結果をすべて大文字で返す。このメソッドは副作用を持たない。
  # upcase_full_name! メソッドを持つ。これは、upcase_full_nameの副作用を持つバージョンで、ファーストネーム、ミドルネーム、ラストネームをすべて大文字に変え、オブジェクトはその状態を記憶する
  extend Forwardable
  delegate [:full_name, :first_name=, :upcase_full_name, :upcase_full_name!] => :@name
  def initialize(first_name, second_name, third_name=nil)
    if third_name
      @name = NameHasMiddleName.new(first_name, second_name, third_name)
    else
      @name = Name.new(first_name, second_name)
    end
  end
end

class BaseName
  attr_writer :first_name

  def upcase_full_name
    full_name.upcase
  end

  def upcase_full_name!
    instance_variables.each do |name|
      instance_eval "#{name.to_s}.upcase!"
    end
    full_name
  end
end


class Name < BaseName
  def initialize(first_name, last_name)
    @first_name = first_name
    @last_name = last_name
  end

  def full_name
    "#{@first_name} #{@last_name}"
  end
end

class NameHasMiddleName < BaseName
  def initialize(first_name, middle_name, last_name)
    @first_name = first_name
    @middle_name = middle_name
    @last_name = last_name
  end

  def full_name
    "#{@first_name} #{@middle_name} #{@last_name}"
  end
end
