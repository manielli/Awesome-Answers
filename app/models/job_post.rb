class JobPost < ApplicationRecord
    belongs_to :user
    validates :title, presence: true
    validates :min_salary, numericality: true
    # When using numericality validation, strings that
    # are only a number (e.g. "1000", "300_123", etc) are
    # considered valid

    def self.search(query)
        # JobPost.all.where()
        # We are already in the JobPost class so we don't need JobPost.all
        where("title ILIKE ?", "%#{query}%")
        # LIKE is case sensitive and ILIKE is case insensitive
    end
end
