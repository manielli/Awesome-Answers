require "http"
require "pp"

# Article & Docs on http.rb:
# https://twin.github.io/httprb-is-great/
# https://github.com/httprb/http

response = HTTP.get("http://localhost:3000/api/v1/questions")

# When HTTP, you must call the .body to access the body of a response.
pp JSON.parse(response.body.to_s).slice(0..2)
