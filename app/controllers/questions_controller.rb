class QuestionsController < ApplicationController
    def new
        @question = Question.new
    end

    def create
        # render json: params => just to render the hash of the params
        @question = Question.new question_params
        
        if @question.save
            redirect_to question_path(@question.id)
        else
            render :new
        end
    end

    def index
        @questions = Question.all.order(created_at: :desc)

        # render json: @questions
    end

    def show
        @question = Question.find params[:id]

        # @question.view_count += 1
        # @question.save
        # render json: @question

        # The method `update_columns` works just like `update`. However,
        # it will skip validations, skip callbacks and will not update `updated_at`
        # Unless you have a very good reason to use this DO NOT USE IT.

        @question.update_columns(view_count: @question.view_count + 1)
    end

    def destroy
        question = Question.find params[:id]
        question.destroy

        redirect_to questions_path
    end 

    def edit
        @question = Question.find params[:id]
    end

    def update
        @question = Question.find params[:id]

        if @question.update question_params
            redirect_to question_path(@question.id)
        else
            render :edit
        end
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
end
