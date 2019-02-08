Rails.application.config.middleware.use OmniAuth::Builder do
    # To get a Github ID and a Github Secret, you must create
    # a Github Developer Application. This the same process that
    # you have to do with nearly every provider.
    provider(
      :github,
      ENV["GITHUB_ID"],
      ENV["GITHUB_SECRET"],
      scope: "read:user,user:email,gist",
    )
  end