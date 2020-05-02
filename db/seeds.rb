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
  user_bio:'Example User1',
)
User.create!(
  name: "Example User2",
  email: "example2@test.com",
  password: "foobar",
  user_bio:'Example User2',
)

10.times do |n|
  comment = "example comment #{n}"
  teaching_material = "example teaching_material #{n}"
  StudyRecord.create!(
    user_id: 1,
    comment: comment,
    teaching_material: teaching_material,
    study_hours: n,
    study_genre_list: ["PHP", "JavaScript", "HTML"]
  )
end

StudyRecordComment.create!(
  user_id: 1,
  study_record_id: 1,
  comment_body: 'コメント'
)
