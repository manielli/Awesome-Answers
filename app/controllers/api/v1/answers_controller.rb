class Api::V1::AnswersController < Api::ApplicationController

    def index
        answers = Answer.order(created_at: :desc)
        render json: answers 
    end
end
