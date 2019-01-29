class LikesController < ApplicationController
    before_action :authenticate_user!

    def create
        question = Question.find(params[:question_id])
        like = Like.new(question: question, user: current_user)

        if !can?(:like, question)
            flash[:warning] = "Don't be a narcissist!"
        elsif like.save
            flash[:success] = "Question Liked"
        else
            flash[:danger] = like.errors.full_messages.join(", ") 
        end
        redirect_to question_path(question.id)
        # Same thing:
        # redirect_to question
        # redirect_to question_path(question)
    end

    def destroy
        like = current_user.likes.find params[:id]
        # like = Like.find params[:id]
        
        if can?(:destroy, like)
            like.destroy
            flash[:success] = "Question Unliked"
        else
            flash[:warning] = "Can't delete like"
        end
        
        redirect_to question_path(like.question.id)
        # redirect_to question_path(like.question) # same thing
    end
    
end
