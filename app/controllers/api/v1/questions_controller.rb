class Api::V1::QuestionsController < Api::ApplicationController
    before_action :authenticate_user!, except: [:index, :show]

    def create
        question = Question.new question_params
        question.user = current_user
        # if question.save
        #     render json: {id: question.id}
        # else
        #     render(json: {errors: question.errors},
        #     status: 422 # Unprocessable Entity
        #     )
        # end
        question.save!
        render json: {id: question.id}
    end
    
    def index
        questions = Question.order(created_at: :desc)
        # questions = Questions.order(created_at: :desc)
        # to cause an error
        render json: questions
    end
    
    def show
        render json: question
    end
    
    def destroy
        question.destroy
        render(json: {status: 200}, status: 200)
    end
    
    private
    def question
        @question ||= Question.find params[:id]
    end
    
    def question_params
        # binding.pry
        params.require(:question).permit(:title, :body, :tag_names)
    end
end
