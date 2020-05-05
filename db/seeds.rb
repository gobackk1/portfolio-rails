# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

User.create!(
  name: "Example User1",
  email: "example1@test.com",
  password: "foobar",
  user_bio:'i am auther',
)
User.create!(
  name: "Example User2",
  email: "example2@test.com",
  password: "foobar",
  user_bio:'i am engineer',
)
User.create!(
  name: "Example User3",
  email: "example3@test.com",
  password: "foobar",
  user_bio:'i am designer',
)

Relationship.create!(
  user_id: 1,
  follow_id: 2
)
Relationship.create!(
  user_id: 1,
  follow_id: 3
)
Relationship.create!(
  user_id: 2,
  follow_id: 3
)

5.times do |n|
  3.times do |m|

    comment = "example comment #{n + 1}"
    teaching_material = "example teaching_material #{n + 1}"
    StudyRecord.create!(
      user_id: 1,
      comment: comment,
      teaching_material: teaching_material,
      study_hours: n + 1,
      study_genre_list: ["PHP", "JavaScript", "HTML"],
      created_at: "2020-05-#{n + 1 + m} 00:00:00",
      updated_at: "2020-05-#{n + 1 + m} 00:00:00",
    )
  end
end

StudyRecord.create!(
  user_id: 1,
  comment: 'comment',
  teaching_material: 'example another teaching_material',
  study_hours: 2,
  study_genre_list: ["PHP", "JavaScript", "HTML"],
  created_at: '2020-05-11 00:00:00'
)


StudyRecordComment.create!(
  user_id: 1,
  study_record_id: 1,
  comment_body: 'コメント'
)
