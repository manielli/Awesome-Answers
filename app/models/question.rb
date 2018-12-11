class Question < ApplicationRecord
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
