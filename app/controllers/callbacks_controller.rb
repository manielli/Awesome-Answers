class CallbacksController < ApplicationController
    def index
        oauth_data = request.env["omniauth.auth"]
        
        # return render json: oauth_data
        user = User.find_by_oauth(oauth_data)
        user ||= User.create_from_oauth(oauth_data)

        # Whenever you sign-in with an oauth provider, the token
        # might change. If this happens, we need to update the user's token
        # in the database. Otherwise, any request we make it might be
        # refused.
    
        if user.oauth_token != oauth_data["credentials"]["token"]
            user.update(
            oauth_token: oauth_data["credentials"]["token"]
            )
        end
        
        if user.valid?
            session[:user_id] = user.id
            flash[:success] = "Thanks for signing in with #{user.provider.capitalize}"
            # flash[:info] = "Token: #{user.oauth_token}"
            flash[:info] = "Token: #{oauth_data["credentials"]["token"]}"
        else
            flash[:danger] = user.errors.full_messages.join(", ")
        end

        redirect_to root_path
    end
end
