require 'http'
require 'pp'

TOKEN = "a3f78d77c4bb59c6ddf67a9370be06efe2ca1d40"

BASE_URL = "https://api.github.com"

response = HTTP
  .headers("Authorization" => "token #{TOKEN}")
  .get("#{BASE_URL}/users/manielli")
#   .get("#{BASE_URL}/users/whilestevego")

pp JSON.parse(response.to_s)