class Question < ApplicationRecord
    belongs_to :user#, optional: true

    has_many :taggings, dependent: :destroy
    has_many :tags, through: :taggings#, source: :tag
    # If the name of the association (i.e. tags) is the 
    # same as the source singularized (i.e. tag), the
    # source argument can be omitted

    has_many :likes, dependent: :destroy
    has_many :likers, through: :likes, source: :user

    # The `dependent` option specifies what happens to records
    # that are dependent on this one (i.e. a question has many answers).
    
    # Passing the `:destroy` tells ActiveRecord to delete the dependents
    # before deleting the owner record. In this case, delete
    # the answers before deleting the question.

    # Passing the value `:nullify` will set the dependent's foreign
    # key column (e.g. question_id) to null allowing the owning record
    # to be destroyed.
    has_many(:answers, dependent: :destroy)

    # `has_many(:answers)` adds the folliwing instance methods
    # to the Question model:

    # answers
    # answers<<(object, ...)
    # answers.delete(object, ...)
    # answers.destroy(object, ...)
    # answers=(objects)
    # answer_ids
    # answer_ids=(ids)
    # answers.clear
    # answers.empty?
    # answers.size
    # answers.find(...)
    # answers.where(...)
    # answers.exists?(...)
    # answers.build(attributes = {}, ...)
    # answers.create(attributes = {})
    # answers.create!(attributes = {})
    # answers.reload
        
    # Association instance methods can be used as part of
    # an Active Record query chain. For example:
    # q.answers.where("id > ?", 10).order(body: :desc).first
    
    # The is Question model for the questions table
    # Raols will attr_accessors for all columns of
    # the table (e.g. id, title, view_count, created_at, updated_at)

    # Create validations by using the `validates` method.
    # The arguments are (in order):
    # - A column name as a symbbol 
    # - Named arguments corresponding to valication riles

    # To read more on validations, go to the following guide:
    # https://guides.rubyonrails.org/active_record_validations.html
    validates(
        :title, 
        presence: true,
        uniqueness: true
    )

    validates(
        :body, 
        presence: {
            message: "must exist"
        },
        length: { minimum: 10 }
    )

    validates(
        :view_count, 
        numericality: {
            greater_than_or_equal_to: 0 # >=
            # lesser_than:
            # greater_than:
        }
    )


    
    # When writing a validation, you can assign a hash to
    # the validation rule and use that hash to configure
    # its different properties. In the example above, we replace
    # the usual message with our own when the presence validation
    # fails.

    # The `presence` refuses any record with the validated column
    # is nil or empty.

    # When a validation fails, ActiveRecord will not save
    # the model instance or changes to the databse.
    # View the validation errors using the methods on
    # .errors method.

    # To list error messages as a hash:
    # q.errors.messages

    # To list them in human friendly manner:
    # q.errors.full_message

    # Use the `valid?` method on a model instance to
    # test all validations. It'll return if the validations
    # success and false otherwise.

    # Custom Validation
    # Be careful, the method for custom validations is
    # singular and its almost exactly same the method
    # for regular validations.
    validate(:no_monkey)

    # Using model lifecycle callbacks
    # To find out more on lifecycle callbacks, go to:
    # https://guides.rubyonrails.org/active_record_callbacks.html

    before_validation(:set_default_view_count)

    def self.all_with_answer_counts
        self
            .left_outer_joins(:answers)
            .select("questions.*", "COUNT(answers.*) AS answers_count")
            .group("questions.id")

        # https://edgeguides.rubyonrails.org/active_record_querying.html#left-outer-joins
    end

    # def like_for
    #     likes.find_by(user: user)
    # end

    # q = Question.first
    # q.tag_names > comma separated list of tags
    # associated with a given question, q.
    def tag_names
        self.tags.map{ |t| t.name }.join(", ")
    end

    # i.e. 
    # 1.tag_names = "stuff, yo"

    # The code in the 👆🏼 example above would call the method
    # we wrote below, where the value on the right hand side
    # of the = would become the argument to the method.
    def tag_names=(rhs)
        self.tags = rhs.strip.split(/\s*,\s*/).map do |tag_name|
            # Find the first record with the given
            # attributes, or initializes a record (Tag.new)
            # with the attributes if one is not found.
            Tag.find_or_initialize_by(name: tag_name)
        end
    end

    private
    def no_monkey
        # &. is the self navigation operator. It's used 
        # like the "." operator to call methods on an object.
        # If the method doesn't exist for the object, `nil`
        # will be returned instead of getting an error
        if body&.downcase&.include?("monkey")
            # To make a record invalid, you must add a validation
            # error using the `errors`' `add` method. Its
            # arguments are (in order):
            # - A symbol for the invalid column
            # - An error message as a string
            self.errors.add(:body, "must not have monkeys")
        end
    end

    def set_default_view_count
        # self.view_count || self.view_count == 0
        # the or=equal (||=) will only assign a value if the
        # assignee is falsy.
        self.view_count ||= 0
    end
end
