class Api::V1::AnswersController < Api::ApplicationController
    before_action :authenticate_user!


    def index
        # question = Question.find params[:question_id]
        # answers = question.answers.order(created_at: :desc)
        answers = Answer.order(created_at: :desc)
        render json: answers 
    end

    # def show
    #     answer = Answer.find params[:id]
    #     render json: answer
    # end

    def destroy
        answer = Answer.find params[:id]
        
        if can? :delete, answer
            answer.destroy
            render json: { status: 200 }, status: 200
        else
            render json: { status: 403 }, status: 403
        end
    end
end
