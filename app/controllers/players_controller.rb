class PlayersController <ApplicationController
    before_action only: [:edit, :update, :destroy] do
        unless ensure_user_logged_in__flash_warn_goes_to_login
            ensure_user_owns_player__flash_danger_goes_to_root
        end
    end

    def new
        contest = Contest.find(params[:contest_id])
        @player = contest.players.build
    end

    def create
        contest = Contest.find(params[:contest_id])
        @player = contest.players.build(valid_params)
        if @player.save
            flash[:success] = 'Successfully created player'
            redirect_to @player
        else
            flash.now[:danger] = 'Input not valid'
            render :new
        end
    end

    def edit
        @player = Player.find(params[:id])
    end

    def update
        @player = Player.find(params[:id])
        if @player.update(valid_params)
            flash[:success] = "Successfully created ${@player.name}"
            redirect_to @player
        else
            flash.now[:danger] = 'Input not valid'
        end
    end

    def destroy
        @player = Player.find(params[:id])
        flash[:success] = "Removed #{@player.name}"
        @player.destroy
        File.delete(@player.file_location)
        redirect_to contest_players_path(@player.contest)
    end

    def show
        @player = Player.find(params[:id])
        @matches = @player.player_matches
    end

    def index
        @contest = Contest.find(params[:contest_id])
        @players = Player.all
    end

    private
        def valid_params
            params.require(:player).permit(:name, description, :downloadable, :playable,:contest_id, :user_id, :upload)
        end
end
