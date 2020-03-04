class SessionsController < ApplicationController

    def new
    end

    def create
        user = User.find_by_email params[:user][:email]
        if user&.authenticate(params[:user][:password])

            # The session is an object usable in controllers that
            # uses cookies to store encrypted data.
            # To sign a user in, we store their "user_id"
            # in the session for later retrieval.

            session[:user_id] = user.id
            flash[:primary] = "Logged In"
            redirect_to root_path
        else
            flash[:primary] = "Email or password is incorrect"
            render :new
        end
    end

    def destroy
        session[:user_id] = nil
        flash[:primary] = "Logged out"
        redirect_to root_path
    end
end