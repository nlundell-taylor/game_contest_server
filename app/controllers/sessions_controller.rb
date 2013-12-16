class SessionsController < ApplicationController
    
    def new
    end

    def create
        @user = User.find_by(username: params[:username])
        if @user and @user.authenticate(params[:password])
            login(@user)
            flash[:success] = "Successfully logged in as #{@user.username}"
            redirect_to @user
        else
            flash.now[:danger] = "Username or password is invalid"
            render 'new'
        end
    end

    def destroy
        cookies.delete :user_id
        flash[:info] = "Successfully logged out"
        redirect_to root_path
    end
end
