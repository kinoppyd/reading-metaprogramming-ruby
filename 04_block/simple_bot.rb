# 次の仕様を満たすSimpleBotクラスとDSLを作成してください
#
# # これは、作成するSimpleBotクラスの利用イメージです
# class Bot < SimpleBot
#   setting :name, 'bot'
#   respond 'keyword' do
#     "response #{settings.name}"
#   end
#
#   after(/response/) do |res|
#     res + ' after filter called'
#   end
# end
#
# Bot.new.ask('keyword') #=> 'respond bot after filter called'
#
# 1. SimpleBotクラスを継承したクラスは、クラスメソッドrespond, after, settingを持ちます
# 2. SimpleBotクラスのサブクラスのインスタンスは、インスタンスメソッドask, settingsを持ちます
#     1. askは、一つの引数をとります
#     2. askに渡されたオブジェクトが、後述するrespondメソッドで設定したオブジェクトと一致する場合、インスタンスは任意の返り値を持ちます
#     3. 2のケースに当てはまらない場合、askメソッドの戻り値はnilです
#     4. settingsメソッドは、任意のオブジェクトを返します
#     5. settingsメソッドは、後述するクラスメソッドsettingによって渡された第一引数と同名のメソッド呼び出しに応答します
# 3. クラスメソッドrespondは、keywordとブロックを引数に取ります
#     1. respondメソッドの第1引数keywordと同じ文字列が、インスタンス変数askに渡された時、第2引数に渡したブロックが実行され、その結果が返されます
# 4. クラスメソッドafterは、conditionとブロックを引数に取ります
#     1. afterメソッドの第1引数に渡されたオブジェクトの `===` メソッドを使い、askメソッドが返そうとしている値と比較します
#     2. もし `===` の比較結果が真であれば、第2引数のブロックを、本来の戻り値を引数にして実行し、それをaskメソッドの返り値とします
# 5. クラスメソッドsettingは、引数を2つ取り、1つ目がキー名、2つ目が設定する値です
#     1. settingメソッドに渡された値は、インスタンスメソッド `settings` から返されるオブジェクトに、メソッド名としてアクセスすることで取り出すことができます
#     2. e.g. クラスメソッドで `setting :name, 'bot'` と実行した場合は、インスタンス内で `settings.name` の戻り値は `bot` の文字列になります
