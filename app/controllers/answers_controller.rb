class AnswersController < ApplicationController
    before_action(:autheticate_user!)

    def create
        @question = Question.find params[:question_id]
        @answer = Answer.new answer_params
        @answer.question = @question


        @answer.user = current_user
        if @answer.save
            redirect_to question_path(@question.id)
        else
            @answers = @question.answers.order(created_at: :desc)
            render "questions/show"
        end

        @answer.save
        # render json: params
    end

    def destroy
        @answer = Answer.find params[:id]
        @answer.destroy
    
        redirect_to question_path(@answer.question)
    end

    private
    def answer_params
        params.require(:answer).permit(:body)
    end
end