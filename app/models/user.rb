class User < ApplicationRecord
    has_many :questions, dependent: :nullify
    has_many :answers, dependent: :nullify
    has_many :job_posts, dependent: :destroy
    # These will nullify user's questions or answers if the user is deleted


    has_many :likes, dependent: :destroy
    has_many :liked_questions, through: :likes, source: :question
    # `has_many` `through:` argument tkaes the name of 
    # another has_many association created with `has_many :association_name`.
    # If we have two has_many :questions one will override the other
    # To fix this we an give the association a different name
    # and specify the `source` option so that Rails will be
    # able to figure out the other end of the association.
    # Note: the source has to match a `belongs_to`
    # association in the join model (like in this case)

    has_secure_password
    # Provides user authentication features on the model it is called in.
    # - Requires a column names password_digest and
    # the gem: bcrypt.
    # It will add two attribute accessors for "password" and
    # "password_confirmation".
    # It will add a presence validation for "password"
    # It will save passwords assigned to "password" using bcrypt gem
    # to hash and store it in the " password_digest" column, meaning
    # we'll never store plain text passwords.

    validates(
        :uid,
        uniqueness: { scope: :provider }
    )

    validates(
        :email,
        presence: true,
        uniqueness: true,
        format: /\A([\w+\-].?)+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i
    )

    def full_name
        "#{first_name} #{last_name}".strip
    end

    def from_oauth?(provider)
        self.uid.present? && self.provider == provider
    end

    def self.find_by_oauth(data)
        self.find_by(
          uid: data["uid"],
          provider: data["provider"]
        )
    end

    def self.create_from_oauth(data)
        names = data["info"]["name"]&.split || [data["info"]["nickname"]]

        self.create(
            first_name: names[0],
            last_name: names[1] || "",
            email: data["info"]["email"],
            uid: data["uid"],
            provider: data["provider"],
            oauth_token: data["credentials"]["token"],
            oauth_raw_data: data,
            password: SecureRandom.alphanumeric(64)
        )
    end
end
