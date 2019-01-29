class AnswerMailer < ApplicationMailer

    def new_answer(answer)
        # We're defining an instance variable here so we can
        # access them in the view file
        @answer = answer
        @question = answer.question
        @owner = @question.user

        mail(
            to: @owner.email,
            subject: 'You got a new answer'
        )
    end
end
