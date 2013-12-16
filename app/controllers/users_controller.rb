class UsersController < ApplicationController
    before_action :ensure_user_not_logged_in__flash_warn_goes_to_root, only: [:new, :create]

    before_action only: [:edit, :update] do
        unless ensure_user_logged_in__flash_warn_goes_to_login
            ensure_correct_user__flash_danger_goes_to_root
        end
    end
    
    before_action :ensure_admin__flash_danger_goes_to_root, only: [:destroy]

    respond_to :html, :json, :xml

    def new
        @user = User.new
        respond_with(@user)
    end

    def create
        @user = User.new(valid_params)
        if @user.save
            flash[:success] = "Hello, {@user.username}"
            login(@user)
        end
        respond_with(@user)
    end

    def edit
        @user = User.find(params[:id])
        respond_with(@user)
    end

    def update
        @user = User.find(params[:id])
        if @user.update(valid_params)
            flash[:success] = "Successfully updated #{@user.username}"
        end
        respond_with(@user)
    end

    def show
        @user = User.find(params[:id])
    end

    def index
        @users = User.all
        respond_with(@users)
    end

    def destroy
        @user = User.find(params[:id])
        if current_user?(@user) then
            flash[:danger] = "Administrator not allowed to delete own account"
            redirect_to root_path
        else
            flash[:success] = "Removed #{@user.username}"
            @user.destroy
            redirect_to users_path
        end
    end
      
    private
        def valid_params
            params.require(:user).permit(:username, :password, :password_confirmation, :email)
        end
end
