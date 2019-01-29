class Tag < ApplicationRecord
    has_many :taggings, dependent: :destroy
    has_many :questions, through: :taggings

    validates :name, presence: true, uniqueness: { case_sensitive: false }
    # the case_sensitive: false option will make uniqueness
    # validation ignore case. For example. two records
    # with the names "ARTS" and "arts" can't both exist

    private
    def downcase_name
        self.name = self.name.downcase_name
        # &. is the safe navigation operator. Like the
        # dot, it will execute a method, however, it will
        # only execute if the caller is not nil.

        self.name&.downcase!
    end

end
