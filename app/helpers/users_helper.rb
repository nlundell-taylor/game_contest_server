module UsersHelper
  
    def contest_creator?(user)
        user.contest_creator
    end

    def ensure_contest_creator__flash_danger_goes_to_root
        unless contest_creator?(current_user)
            flash[:danger] = "Action not allowed for #{current_user.username}"
            redirect_to root_path
        end
    end
end
