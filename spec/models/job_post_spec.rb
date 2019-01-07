require 'rails_helper'

RSpec.describe JobPost, type: :model do
  # pending "add some examples to (or delete) #{__FILE__}"

  # The `describe` is used to group related test together.
  # It's primarily an organizational tool.
  # All the tests are part of the group should be writte
  # inside of the block passed to `describe`.
  describe ".search" do
    # To implement a test, use the `it` method
    # that takes the following arguments:
    # - A description of what is being tested as a string
    # - A block where the resting logic is written
    it("returns 2 job posts") do
      #  GIVEN
      # 3 job posts in the database
      job_post_a = JobPost.create(
        title: "Software Engineer",
        min_salary: 60_000
      )
      job_post_b = JobPost.create(
        title: "Programmer",
        min_salary: 60_000
      )
      job_post_c = JobPost.create(
        title: "Software QA",
        min_salary: 35_000
      )

      #  WHEN
      # Search for "software"
      results = JobPost.search("software")

      # THEN
      # JobPost A & C are returned

      # RSpec matchers:
      # https://relishapp.com/rspec/rspec-expectations/docs/built-in-matchers

      # Use `expect` instead of `assert_*` to verify tests
      # in RSpec.
      # The `expect` takes a value to be tested. It returns
      #  an object to `to` that we called and we pass
      #  matcher that tells how to verify the value.
      expect(results).to(eq([job_post_a, job_post_c]))
      # expect(results).to eq([job_post_a, job_post_c])
    end
  end

  # We only include tests for validations
  describe "validates" do
    it("requires a title") do
      # GIVEN
      # An instance of a JobPost
      job_post = JobPost.new

      # WHEN
      # Validations are triggered
      job_post.valid?

      # Then
      # There's an error related to the title
      # in the error object

      # The following will pass the test if errors.messages
      # hash has a key named :title. This only occurs when
      # a "title" validation fails.
      expect(job_post.errors.messages).to(have_key(:title))
    end

    it("requires that min_salary is a number") do
      # job_post = JobPost.new(min_salary: "1000") initially was this and it gave and error when running rspec
      job_post = JobPost.new(min_salary: "one hundred")

      job_post.valid?

      expect(job_post.errors.messages).to(have_key(:min_salary))
    end
  end
end
