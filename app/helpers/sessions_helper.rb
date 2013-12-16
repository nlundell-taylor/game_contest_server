module SessionsHelper
    
    def logged_in?
        !current_user.nil?
    end

    def current_user
        @current_user ||= User.find(cookies.signed[:user_id]) if cookies.signed[:user_id]
    end

    def current_user?(user)
        current_user == user
    end

    def login(user)
        cookies.signed[:user_id] = user.id
    end

    def ensure_user_not_logged_in__flash_warn_goes_to_root
        if logged_in?
            flash[:warning] = "Cannot logged in"
            redirect_to root_path
        end
    end

    def ensure_user_logged_in__flash_warn_goes_to_login
        unless logged_in?
            flash[:warning] = "Must be logged in"
            redirect_to login_path
        end
    end

    def ensure_correct_user__flash_danger_goes_to_root
        @user = User.find(params[:id])
        unless current_user?(@user)
            flash[:danger] = "Action not allowed for #{current_user.username}"
            redirect_to root_path
        end
    end

    def ensure_admin__flash_warn_goes_to_root
        unless current_user.admin?
            flash[:warning] = "Must be an administrator"
            redirect_to root_path
        end
    end

    def ensure_admin__flash_danger_goes_to_root
        unless current_user.admin?
            flash[:danger] = "Must be an administrator"
            redirect_to root_path
        end
    end

    def ensure_user_owns_referee__flash_danger_goes_to_root
        @referee = Referee.find(params[:id])
        @user = @referee.user
        unless current_user?(@user)
            flash[:danger] = "Action not allowed for #{current_user.username}"
            redirect_to root_path
        end
    end
    
    def ensure_user_owns_contest__flash_danger_goes_to_root
        @contest = Contest.find(params[:id])
        @user = @contest.user
        unless current_user?(@user)
            flash[:danger] = "Action not allowed for #{current_user.username}"
            redirect_to root_path
        end
    end

    def ensure_user_owns_player__flash_danger_goes_to_root
        @player = Player.find(params[:id])
        @user = @player.user
        unless current_user?(@user)
            flash[:danger] = "Action not allowed for #{current_user.username}"
            redirect_to root_path
        end
    end
end