class QuestionsController < ApplicationController
    before_action :find_question, only: [:show, :edit, :update, :destroy]
    before_action :authenticate_user!, except: [:index, :show]
    before_action :authorize_user!, only: [:edit, :update, :destroy]

    def new
        @question = Question.new
    end

    def create
        # render json: params => just to render the hash of the params
        @question = Question.new question_params
        @question.user = current_user # if current_user.present? we don't 
        # need this file because the user doesn't get to this page if they
        # are not a user
        
        if @question.save
            redirect_to question_path(@question.id)
        else
            render :new
        end
    end

    def index
        @questions = Question.all_with_answer_counts.order(created_at: :desc)

        # render json: @questions
    end

    def show
        # @question = Question.find params[:id]
        # We'll get rid of this because we have before_action at the top
        # and the private find_question method

        @answers = @question.answers.order(created_at: :desc)
        @answer = Answer.new
        
        # @question.view_count += 1
        # @question.save
        # render json: @question

        # The method `update_columns` works just like `update`. However,
        # it will skip validations, skip callbacks and will not update `updated_at`
        # Unless you have a very good reason to use this DO NOT USE IT.

        @question.update_columns(view_count: @question.view_count + 1)
    end
    
    def edit
        # @question = Question.find params[:id]
        # We'll get rid of this because we have before_action at the top
        # and the private find_question method
    end
    
    def update
        # @question = Question.find params[:id]
        # We'll get rid of this because we have before_action at the top
        # and the private find_question method
        
        if @question.update question_params
            redirect_to question_path(@question.id)
        else
            render :edit
        end
    end
    
    def destroy
        # question = Question.find params[:id]
        # question.destroy
        # We'll get rid of this because we have before_action at the top
        # and the private find_question method

        @question.destroy
        redirect_to questions_path
    end

    private
    def question_params
        # Use the require method on the params object to retrieve
        # the nested hash of a key usually corresponding with the
        # name-value pairs of a form.

        # Then, use `permit` to specify all input names that are allowed
        # as symbols.
        params.require(:question).permit(:title, :body)
    end

    def find_question
        @question = Question.find params[:id]
    end

    def authorize_user!
        # We add a ! to the name of this method as a convention, because
        # it can mutate the `response` object of our controller.
        # Terminating it prematurely.
        unless can?(:crud, @question)
            flash[:danger] = "Access Denied!"
            redirect_to question_path(@question)
        end
    end
end