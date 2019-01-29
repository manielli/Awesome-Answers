class QuestionSerializer < ActiveModel::Serializer
  # Use the attributes method to specify
  # methods of a model to include in the
  # serialization output.
  # All columns of a model have a corresponding
  # att_reader therefore we can filter this way
  # as well.
  attributes(
    :id,
    :title,
    :body,
    :like_count,
    :created_at,
    :updated_at,
    :view_count
  )

  # To include associated models, use the same
  # anmed methods used for creating associations. You
  # can rename the association with "key" which is only
  # going to show in the renderred json.
  belongs_to(:user, key: :author)
  has_many(:answers)

  # class AnswerSerializer < ActiveModel::Serializer
  #   attributes :id, :body, :created_at, :updated_at

  #   belongs_to(:user, key: :author)
  # end

  # You can create methods in a serializer to include custom
  # data in the json serialization. When doing so,
  # make sure to include the name of the method in
  # the attributes call.
  def like_count
    object.likes.count
  end
end
