FactoryBot.define do
  # FactoryBot.attributes_for(:job_post)
  # Returns a plain hash of the parameters required to create
  # a JobPost

  # FactoryBot.build(:job_post)
  # Returns a new un-persisted unstance of a JobPost (using the factory)

  # FactoryBot.create(:job_post)
  # returns a persisted instance of JobPost (using the factory)

  # All you factories must always generate valid instances of
  # your data. ALWAYS!
  factory :job_post do
    # title { "Software Wizard" }
    # description { "Some stuff" }
    # company { "Mashkbook" }
    # min_salary { 90_000 }
    # max_salary { 300_000 }

    # The line below will create a user (using
    # its factory) before creating a job post. This is 
    # necessary to pass the validation added by 
    # `belongs_to(:user)`
    association(:user)

    title { Faker::Job.title }
    description { Faker::Job.field }
    company { Faker::Company.name }
    min_salary { rand(20_001..100_000) }
    max_salary { rand(100_001..300_000) }

  end
end
