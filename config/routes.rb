Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  # Question Related Routes
  get("/questions/new", to: "questions#new", as: :new_question)
  # new_question_path, new_question_url
  post("/questions", to: "questions#create", as: :questions)
  # questions_path, question_url

  get("/questions", to: "questions#index")
  get("/questions/:id", to: "questions#show", as: :question)
  # question_path(<id>), question_url(<id>)
  delete("questions/:id", to: "questions#destroy")
  get("/questions/:id/edit", to: "questions#edit", as: :edit_question)
  #edit_question_path(<:id>), edit_question_url(<:id>)
  patch("/questions/:id", to: "questions#update")

  # To create, use methods named after HTTP
  # verbs. This includes: get, post, put, patch, delete, etc.

  # As a first argument, write a URL path as a string.
  # (e.g. "/", "/hello_world", "/posts/:id", etc)

  # Then, provide the named argument "to" with string that
  # describes the controller method that will be used to create
  # response to the client's request.

  # Example: 
  # `to: "welcome#incdex"` directs the request to
  # the `WelcomeController`'s index public method
  # `to: "posts#show"` direct the request to a
  # "PostsController"'s `show` method.

  get("/", to: "welcome#index", as: :root)
  # Routes in rails define methods named after
  # the route's path or the value given to the
  # 'as' argument.
  # For the route above the following methods are defined:
  # root_path # => "/"
  # root_url # => "http://localhost:3000/"

  get("/contact_us", to: "welcome#contact")
  # contact_us_path => "/contact_us"
  # contact_us_url => "http://localhost:3000/contact_us"
  
  post(
    "/contact_us/process", 
    to: "welcome#process_contact", 
    as: :process_contact
    )

  # process_contact_path => /contact_us/process
  # process_contact_url => http://localhost:3000/contact_us/process

  # vs. Express
  # router.get ("/contact_us", (req, res) => { ... })

  # To list all of your routes, use the command:
  # rails routes


end
