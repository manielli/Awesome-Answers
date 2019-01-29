require 'rails_helper'

# When running the RSpec command you can specify a specific
# test file to run, do:
# `rspec ./spec/controllers/job_posts_controller_spec.rb`

# You can also specify a single test to run at a line number by
# doing the following:
# `rspec ./spec/controllers/job_posts_controller_spec.rb:6`

RSpec.describe JobPostsController, type: :controller do 
    def current_user
        @current_user ||= FactoryBot.create(:user)
    end
    
    describe "#new" do
        context "without signed in user" do
            it "redirects the user to session new" do
                get(:new)
    
                expect(response).to redirect_to(new_session_path)
            end
    
            it "sets a danger flash message" do
                get(:new)

                expect(flash[:danger]).to be
            end
        end   

        context "when signed in user" do
            # Use `before` to run a block of code before all tests
            # inside of a block. In this case, the following
            # block will run before the two tests inside this
            # context's block.
            before do
                # To simulate signing in a user, set a `user_id` in the
                # `session`. RSpec makes controller's session available
                # inside your tests.
                session[:user_id] = current_user.id
            end

            it "renders a new template" do
                # GIVEN
                # Defaults

                # WHEN
                # Making a GET request to the new action
                get(:new)

                # THEN
                # The `response` contains the rendered template of `new`

                # The `response` object is available inside any controller. It is
                # similar to the `response` available in Express Middleware
                # However we rarely interact directly with it in Rails. RSpec
                # makes it available when testing to verify its contents.

                # Here we verify with the `render_template` matcher that it contains
                # the right rendered template.
                expect(response).to(render_template(:new))
            end

            it "sets an instance variable with a new job post" do 
                get(:new)

                # assigns(:job_post)
                # Return the value of the instance variable @job_post from the
                # instance of our JobPostsController.
                # Only available if the gem "rails-controller-testing" is installed

                expect(assigns(:job_post)).to(be_a_new(JobPost))
                # The above matcher will verify that the expected value is a
                # new instance of the JobPost model.
            end
        end
    end

    describe "#create" do

        def valid_request
            # The post method below simulates an HTTP request to the create action
            # of the JobPostsController using the POST verb.

            # This has the effect of simulating a user filling our new form
            # in a browser and submitting.
            post(:create, params: { job_post: FactoryBot.attributes_for(:job_post) })
        end
        context "without signed in user" do
            it "redirects to the new session" do
                valid_request
                
                expect(response).to redirect_to(new_session_path)
            end
        end
        
        context "with signed in user" do
            before do
                session[:user_id] = current_user.id
            end

            context "with valid parameters" do 
    
                it "creates a new job post" do
                    count_before = JobPost.count
                    valid_request
                    count_after = JobPost.count
    
                    expect(count_after).to eq(count_before + 1)
                end
                
                it "redirects to the show page of that post" do 
                    valid_request
    
                    job_post = JobPost.last
    
                    expect(response).to(redirect_to(job_post_url(job_post.id)))
                end

                it "associates the current user to the created job post" do
                    valid_request

                    job_post = JobPost.last
                    expect(job_post.user).to eq(current_user)
                end
            end
    
            context "with invalid parameters" do
                def invalid_request
                    post(
                        :create,
                        params: { job_post: FactoryBot.attributes_for(:job_post, title: nil) }
                    )
                end
    
                it "doesn't create a job post" do
                    count_before = JobPost.count
                    invalid_request
                    count_after = JobPost.count
            
                    expect(count_after).to eq(count_before)
                end
    
                it "renders the new template" do
                    invalid_request
    
                    expect(response).to render_template(:new)
                end
    
                it "assigns an invalid job post as an instance var." do 
                    invalid_request
    
                    expect(assigns(:job_post)).to be_a(JobPost)
                    expect(assigns(:job_post).valid?).to be(false)
                end
            end
        end
    end

    describe "#show" do 
        it "render the show template" do 
            # GIVEN
            # A job post in the db
            job_post = FactoryBot.create(:job_post)

            # WHEN
            # A GET to /posts/:id
            get(:show, params: { id: job_post.id })

            # THEN
            # The response contains the rendered show template
            expect(response).to render_template(:show)
        end

        it "set @job_post for the shown object" do
            job_post = FactoryBot.create(:job_post)
      
            get(:show, params: { id: job_post.id })
      
            expect(assigns(:job_post)).to eq(job_post)
        end
    end

    describe "#destroy" do
        context "without signed in user" do
            it "redirects to new session" do
                job_post = FactoryBot.create(:job_post)
      
                delete(:destroy, params: { id: job_post.id })
        
                expect(response).to redirect_to(new_session_path)
            end
        end

        context "with signed in user" do
            before do
                session[:user_id] = current_user.id
            end
            
            context "as non-owner" do
                it "doesn't remove a job post" do
                    job_post = FactoryBot.create(:job_post)
                    delete(:destroy, params: {id: job_post.id})

                    expect(JobPost.find_by(id: job_post.id)).to(eq(job_post))
                end

                it "redirects to the job post show" do
                    job_post = FactoryBot.create(:job_post)
                    delete(:destroy, params: { id: job_post.id})

                    expect(response).to redirect_to(job_post_url(job_post.id))
                end

                it "flashes a danger message" do
                    job_post = FactoryBot.create(:job_post)
                    delete(:destroy, params: {id: job_post.id})

                    expect(flash[:danger]).to be
                end
            end

            context "as owner" do
                it "removes a job post from the db" do
                    job_post = FactoryBot.create(:job_post, user: current_user)
                    delete(:destroy, params: {id: job_post.id})
        
                    expect(JobPost.find_by(id: job_post.id)).to be(nil)
                end
        
                it "redirects to the job post index" do
                    job_post = FactoryBot.create(:job_post, user: current_user)
                    delete(:destroy, params: { id: job_post.id })
            
                    expect(response).to redirect_to(job_posts_url)
                end
            end
        end
    end
end
