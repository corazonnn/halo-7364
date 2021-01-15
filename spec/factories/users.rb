#完了テストコード用のオブジェクト
FactoryBot.define do
  factory :user do
    username {"ルフィ太郎"}
    language {"Ruby"}
    introduction {"海賊王に俺はなる"}
    sequence(:email) { |n| "ruffy#{n}@ruffy.com"}
    password {"ruffy"}
    
    #よくわからないけど書くっぽい→書かなくてもいいっぽい
    #activated true
  end
end