class Answer < ApplicationRecord
  # Be default, `belongs_to` will create a validation
  # such as `validates(:question_id, presence: true)`.
  # It can be disabled, by passing the argument
  # `optional: true` to the `belongs_to` method

  belongs_to :question
  belongs_to :user

  # In an associate between two tables, the model that
  # has the `belongs_to` method is always the model that
  # has the foreign key column (i.e. question_id)


  # The following instance methods are added to the answer
  # model by the lin `belongs_to :question`:

  # question
  # question=(associate)
  # build_question(attributes = {})
  # create_question(attributes = {})
  # create_question!(attributes = {})
  # reload_question

  # Methods that save records to the db that end
  # with `!` (e.g. save!, create_question!) raise an error
  # when a validation fails instead of returning `false`.

  validates(:body, presence: true)
end

=begin

SELECT questions.*, COUNT(answers.*) AS answers_count FROM questions
  LEFT JOIN answers ON questions.id = answers.question_id
  GROUP BY questions.id;

=end