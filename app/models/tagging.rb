class Tagging < ApplicationRecord
  belongs_to :question
  belongs_to :tag

  
  validates(
    :tag_id,
    uniqueness: {
      scope: :question_id,
      message: "Has already been tagged"
    }
  )
end
