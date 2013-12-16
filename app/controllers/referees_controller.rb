class RefereesController < ApplicationController
    before_action only: [:new, :create] do
        unless ensure_user_logged_in__flash_warn_goes_to_login
            ensure_contest_creator__flash_danger_goes_to_root
        end
    end

    before_action only: [:edit, :update] do
        unless ensure_user_logged_in__flash_warn_goes_to_login
            ensure_user_owns_referee__flash_danger_goes_to_root
        end
    end

    before_action only: [:destroy] do
        unless ensure_user_logged_in__flash_warn_goes_to_login
            ensure_user_owns_referee__flash_danger_goes_to_root
        end
    end

    def new
        @referee = current_user.referees.build
    end

    def create
        @referee = current_user.referees.build(valid_params)
        if @referee.save
            flash[:success] = 'Successfully created referee'
            redirect_to @referee
        else
            flash.now[:danger] = "Input not valid"
            render :new
        end
    end

    def edit
        @referee = Referee.find(params[:id])
    end

    def update
        @referee = Referee.find(params[:id])
        if @referee.update(valid_params)
            flash[:success] = "Successfully updated #{@referee.name}"
            redirect_to @referee
        else
            flash.now[:danger] = "Input not valid"
            render :edit
        end
    end


    def show
        @referee = Referee.find(params[:id])
    end

    def index
        @referees = Referee.all
    end

    def destroy
        @referee = Referee.find(params[:id])
        flash[:success] = "Removed #{@referee.name}"
        @referee.destroy
        File.delete(@referee.file_location)
        redirect_to referees_path
    end

    private
		def valid_params
			params.require(:referee).permit(:name, :rules_url, :players_per_game, :upload)
		end
end