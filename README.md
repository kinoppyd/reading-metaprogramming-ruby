# reading-metaprogramming-ruby

## これはなに

このリポジトリは、[メタプログラミングRuby 第2版](https://www.oreilly.co.jp/books/9784873117430/)を読んだ人向けの練習問題集です。本を読んだだけだとなかなか身につかないRubyのメタプログラミングの知識を、手を動かして理解することを目的にしています。

## 始め方

まずこのリポジトリをcloneしてbundle installまでしておきます。対象としているRubyのバージョンは3.4です。

`02_object_model`のように、頭に章番号がふってあるディレクトリが、その章で学んだ内容を問う問題にあたります。`00_setup`は練習問題の解き方を練習するための問題です。

各章のディレクトリ中には練習問題があります。各ファイルには`01_method_first_step.rb`のように先頭に番号が振ってあるので、番号順で解くのをオススメしています。ファイルの中には日本語で満たすべき仕様と、いくらかのコードが記述されています。

各ディレクトリには問題だけでなく、テストも付属しています。各章のディレクトリに移動して`bundle exec rake`とするとテストを実行できます。プロジェクトのルートディレクトリで`bundle exec rake`をすると、すべての問題のテストを実行します。

問題文に示された仕様が満たされるとテストがパスするようになっています。頑張ってテストをパスするコードを書いてみましょう。もしテストと仕様の文章が違うなどの不備を見つけたらプルリクエストを送ってもらえると嬉しいです。

単体でテストを実行したい場合は`bundle exec ruby -I../test test/test_method_first_step.rb`のようにするとできます。

## 解答例

問題を解こうとしたけれどよくわからなかった、とかテストはパスしたけれどこれが良いコードなのかわからない、という人のために解答例と解説をanswersディレクトリ配下に置いています。適宜参考にしつつメタプログラミングの理解を深めてください。

もっと良い解答例がある場合はプルリクエストを送ってもらえると嬉しいです。




