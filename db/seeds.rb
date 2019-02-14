# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

Answer.destroy_all
Question.destroy_all
JobPost.destroy_all
User.destroy_all
Like.destroy_all
Tag.destroy_all
Tagging.destroy_all
AdminUser.destroy_all

# `Tag.destroy_all` should take care of `Tagging.destroy_all` 
# because they are dependent but we just put it in case

PASSWORD = "supersecret"


super_user = User.create(
    first_name: "Jon", 
    last_name: "Snow", 
    email: "js@winterfell.gov", 
    password: "daenerystargaryen",
    address: "142 West Hastings Street, Vancouver, BC",
    admin: true
)
super_user.geocode!
super_user.save!

10.times do
    first_name = Faker::FunnyName.two_word_name.split(" ").first
    last_name = Faker::FunnyName.two_word_name.split(" ").last
    

    u = User.create(
        first_name: first_name,
        last_name: last_name,
        email: "#{first_name.downcase}-#{last_name.downcase}@example.com",
        password: PASSWORD
    )
end

users = User.all

10.times do
    Tag.create(
        name: Faker::Book.genre
    )
end

tags = Tag.all

200.times do
    created_at = Faker::Date.backward(365 * 5)

    q = Question.create(
        # Faker is a ruby module. We access classes or other modules
        # inside of module with ::. Here Hacker is a class inside of the
        # Faker module.
        title: Faker::Hacker.say_something_smart,
        body: Faker::ChuckNorris.fact,
        view_count: rand(100_000),
        created_at: created_at,
        updated_at: created_at,
        user: users.sample,
        # aasm_state: [:draft, :published, :answered, :not_answered, :archived]
        aasm_state: Question.aasm.states.map(&:name).sample
    )

    if q.valid?

        q.likers = users.shuffle.slice(0, rand(users.count))
        q.tags = tags.shuffle.slice(0, rand(tags.count/2))

        rand(0..15).times do
            q.answers << Answer.new(
                body: Faker::GreekPhilosophers.quote,
                user: users.sample
            )
        end
    end

end

questions = Question.all
answers = Answer.all
likes = Like.all

puts Cowsay.say("Generated #{questions.count} questions", :frogs)
puts Cowsay.say("Generated #{answers.count} answers", :sheep)
puts Cowsay.say("Generated #{users.count} users", :dragon)
# puts Cowsay.say("Login with #{super_user.email} and password: daenerystargaryen", :ghostbusters)
puts Cowsay.say("Generated #{likes.count} likes", :cheese)
puts Cowsay.say("Generated #{tags.count} tags", :koala)
AdminUser.create!(email: 'admin@example.com', password: 'password', password_confirmation: 'password') if Rails.env.development?