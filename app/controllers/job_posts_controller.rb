class JobPostsController < ApplicationController
    before_action :authenticate_user!, only: [:new, :create, :destroy]

    def new
        @job_post = JobPost.new
    end

    def create
        @job_post = JobPost.create job_post_params
        @job_post.user = current_user
        # binding.pry 
        # when we run a test or run the app, it stops at this point 
        # and let us inspect in pry our variables and everyting

        if @job_post.save
            redirect_to job_post_url(@job_post.id)
        else
            render :new
        end
    end

    def show
        @job_post = JobPost.find params[:id]
    end

    def destroy
        job_post = JobPost.find params[:id]

        if can?(:delete, job_post)
            job_post.destroy
            
            redirect_to job_posts_url
        else
            flash[:danger] = "Access Denied"
            redirect_to job_post_url(job_post.id)
        end
    end

    private
    def job_post_params
        params.require(:job_post).permit(:title, :description, :min_salary, :max_salary, :company)
    end
end
