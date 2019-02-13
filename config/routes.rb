Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  
  get "/auth/github", as: :sign_in_with_github
  get "/auth/:provider/callback", to: "callbacks#index"

  match "/delayed_job" => DelayedJobWeb, :anchor => false, :via => [:get, :post]

  resources :job_posts, only: [:new, :create, :show, :destroy]

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  

  # resources :sessions, only: [:new, :create, :destroy]
  # resource is singular rather than resources
  # Unlike resources, resource will create routes
  # that do CRUD operations on only on thing.
  # There will be no index route, and no route,
  # and it will have a ":id" wildcard. The controller
  # name must still be plural.

  resource :session, only: [:new, :create, :destroy]
  resources :users, only: [:new, :create]
  
  
  resources :answers

  # `resources` method will generate all CRUD routes following
  # RESTful conventions for a resource. It will assume there is a 
  # controller named after the first argument pluralized and PascalCased.
  # (i.e. :question => QuestionsController)

  resources :questions do
    
    resources :publishings, only: :create


    # /questions/:id/publish_gist
    post :publish_gist, on: :member

    # Routes written inside of a block passed
    # to a `resources` method will be pre-fixed
    # by a path corresponding to the passed in symbol.
    # In this case, all nested routes will be
    # prefixed with `/questions/:question_id/`
    resources :answers, only: [:create, :destroy]
    # question_answers_path(<question-id>), question_answer_url
    # question_answers_path(@question.id)


    # We could also add :index instead of get :liked, on: :collection we added below
    resources :likes, shallow: true, only: [:create, :destroy]
    # The shallow: true named argument will separate routes
    # that require the parent from those that don't.
    # Routes that require the parent won't change
    # (i.g. index, new, create)
    # Routes that don't require the parent
    # (e.g. show, efit, update, destroy) will have the
    # parent prefix (i.e. /question/:question_id) removed.

    # Example
    # /questions/10/likes/9/edit becomes /likes/9/edit

    get :liked, on: :collection
    # /questions/liked
    # Use the "on" named argument to specity how a
    # nested route behaves relative to its parent

    # `on: :collection` means that it acts on the 
    # entire resource. All questions in this case. `new`
    # and `create` act on the collection

    # get :also_liked, on: :member
    # `on: :member` means that it acts on a single resource.
    # A single question, in this case. `edit`, 
    # `update`, `destroy`, `show` are all member routes
  end

    
  
  # # Question Related Routes
  # get("/questions/new", to: "questions#new", as: :new_question)
  # # new_question_path, new_question_url
  # post("/questions", to: "questions#create", as: :questions)
  # # questions_path, questions_url
  # get("/questions", to: "questions#index")
  # get("/questions/:id", to: "questions#show", as: :question)
  # # question_path(<id>), question_url(<id>)
  # delete("questions/:id", to: "questions#destroy")
  # get("/questions/:id/edit", to: "questions#edit", as: :edit_question)
  # #edit_question_path(<:id>), edit_question_url(<:id>)
  # patch("/questions/:id", to: "questions#update")

  # To create, use methods named after HTTP
  # verbs. This includes: get, post, put, patch, delete, etc.

  # As a first argument, write a URL path as a string.
  # (e.g. "/", "/hello_world", "/posts/:id", etc)

  # Then, provide the named argument "to" with string that
  # describes the controller method that will be used to create
  # response to the client's request.

  # Example: 
  # `to: "welcome#index"` directs the request to
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

  # The option defaults: {format: json} will se json
  # as a the default response for all routes.
  # The namespace method in Rails makes it so it will
  # automcatically look in a directory `api`, then
  # in a subdirectory v1
  namespace :api, defaults: {format: :json} do
    namespace :v1 do
      
      # resources :answers, only: [:index, :destroy]
      
      resources :questions, only: [:show, :index, :create, :destroy] do
        resources :answers, only: [:index, :destroy]
      end
      
      resource :session, only: [:create, :destroy]
      
      resources :users, only: [] do
        # get :current # /api/v1/users/:user_id/current
        # get :current, on: :member # /api/v1/users/:id/current
        get :current, on: :collection # /api/v1/users/current
      end

    end

    # The following routes will match any URL that hasn't been
    # matched already inside of the "/api" namespace.
    
    # The "*" prefix in the routes path allows this route wildcard
    # match ANYTHING.
  
    # The "via:" argument is required and is used to specify
    # which methods this route applies to.
    # Example: 
    # `via: [:get, :post, :patch]`
    # `via: :all` will match all mpossible methods.
  
    match "*unmatched", via: :all, to: "application#not_found"
  end

end
