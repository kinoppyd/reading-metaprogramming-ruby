class TryOut

  def initialize(*names)
    raise ArgumentError if names.length <= 1 || names.length > 3

    middle_name = names[1] if names.length == 3

    @first_name = names.first
    @middle_name = middle_name
    @last_name = names.last
  end

  def full_name
    middle = "#{@middle_name} " if @middle_name
    "#{@first_name} #{middle}#{@last_name}"
  end

  def first_name=(first_name)
    @first_name = first_name
  end

  def upcase_full_name
    full_name.upcase
  end

  def upcase_full_name!
    @first_name.upcase!
    @middle_name&.upcase!
    @last_name.upcase!

    full_name
  end
  # このクラスの仕様
  # コンストラクタは、2つまたは3つの引数を受け付ける。引数はそれぞれ、ファーストネーム、ミドルネーム、ラストネームの順で、ミドルネームは省略が可能。
  # full_nameメソッドを持つ。これは、ファーストネーム、ミドルネーム、ラストネームを半角スペース1つで結合した文字列を返す。ただし、ミドルネームが省略されている場合に、ファーストネームとラストネームの間には1つのスペースしか置かない
  # first_name=メソッドを持つ。これは、引数の内容でファーストネームを書き換える。
  # upcase_full_nameメソッドを持つ。これは、full_nameメソッドの結果をすべて大文字で返す。このメソッドは副作用を持たない。
  # upcase_full_name! メソッドを持つ。これは、upcase_full_nameの副作用を持つバージョンで、ファーストネーム、ミドルネーム、ラストネームをすべて大文字に変え、オブジェクトはその状態を記憶する
end
