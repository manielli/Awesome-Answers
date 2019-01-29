class Like < ApplicationRecord
  belongs_to :user
  belongs_to :question

  # This will ensure that the question_id / user_id
  # combo is unique. We use this to ensure that
  # the user can only like a question once.
  validates(
    :question_id,
    uniqueness: {
      scope: :user_id,
      message: "has already been liked"
    }
  )
end
