class UsersController < ApplicationController

    def new
        @user = User.new
    end

    def create
        @user = User.new user_params
        # @user.slug = nil
        if @user.save
            session[:user_id] = @user.id
            flash[:primary] = "Signed Up"
            redirect_to root_path
        else
            render :new
        end
    end

    def show
        @user = User.find params[:id]
        if @user.longitude && @user.latitude
          @nearby_users = User.near([@user.latitude, @user.longitude], 100, units: :km)
        end
    end

    private
    def user_params
        params.require(:user).permit(:first_name, :last_name, :email, :password, :password_confirmation)
    end
end
