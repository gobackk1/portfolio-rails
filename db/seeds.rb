# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

user_count = 20
study_record_count = 10
study_record_per_user = 10
tag_list = ["タグ1","タグ2","タグ3","タグ4","タグ5"]
t_material = {
  0 => "英語",
  1 => "国語",
  2 => "数学",
  3 => "社会",
  4 => "物理"
}

def genRandomTag(tag_list)
  list = tag_list.dup
  length = rand(1..5)
  counter = list.length - 1
  result = []
  length.times do
    result << list.slice!(rand(counter))
    counter -= 1
  end
  result
end

User.create(
  name: "kawabata kengo",
  email: "auth@example.com",
  password: "foobar",
  user_bio:'私は管理ユーザーです。',
)

user_count.times do |n|
  gimei = Gimei.unique.name
  address = Gimei.unique.address
  User.create(
    name: gimei.romaji,
    email: "user_#{n + 1}@example.com",
    password: "foobar",
    user_bio: "私は#{address.prefecture.kanji}出身の#{gimei.gender == :male ? "男性" : "女性"}です。"
  )
end

Relationship.create(
  user_id: 1,
  follow_id: 2
)
Relationship.create(
  user_id: 1,
  follow_id: 3
)
Relationship.create(
  user_id: 2,
  follow_id: 3
)

study_record_count.times do |n|
  user = User.find(n + 1)
  comment = "コメントのサンプルです。 #{n + 1}"
  study_record_per_user.times do |m|
    user.study_records.create(
      comment: comment,
      teaching_material: t_material[rand(4)],
      study_hours: rand(1..5),
      study_genre_list: genRandomTag(tag_list),
      created_at: "2020-05-#{m + 1} 09:00:00",
      updated_at: "2020-05-#{m + 1} 09:00:00",
    )
  end
end

StudyRecordComment.create(
  user_id: 1,
  study_record_id: 1,
  comment_body: 'コメント'
)
