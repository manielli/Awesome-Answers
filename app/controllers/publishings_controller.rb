class PublishingsController < ApplicationController

    def create
        q = Question.find params[:question_id]
        q.publish!

        # redirect_to question_path(q), notice: "Question published"
        # redirect_to q, notice: "Question published"
        redirect_to q
        flash[:success] = "Question published!"
    end

end