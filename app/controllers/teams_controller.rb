class TeamsController < ApplicationController
  # GET /teams
  # GET /teams.xml
  def index
  	if (params[:id].nil?)
      @teams = Team.all
    else
      @teams = Tournament.find(params[:id]).teams
    end

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @teams }
    end
  end

  # GET /teams/1
  # GET /teams/1.xml
  def show
    @team = Team.find(params[:id])
    @player = Player.new( :team => @team, :team_id => @team.id )

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @team }
    end
  end

  # GET /teams/new
  # GET /teams/new.xml
  def new
    @team = Team.new( :tournament_id => params[:id] )

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @team }
    end
  end

  # GET /teams/1/edit
  def edit
    @team = Team.find(params[:id])
  end

  # POST /teams
  # POST /teams.xml
  def create
    bitwise = params[:team][:bit_wise]
    params[:team].delete(:bit_wise)
    @team = Team.new(params[:team])
    @team.bitwise_games_played = 0
    if !bitwise.nil?
	    bitwise.each do |b|
			@team.bitwise_games_played |= b.to_i
		end
	end
    respond_to do |format|
      if @team.save
        flash[:notice] = 'Team was successfully created.'
        format.html { redirect_to(@team) }
        format.xml  { render :xml => @team, :status => :created, :location => @team }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @team.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /teams/1
  # PUT /teams/1.xml
  def update
    @team = Team.find(params[:id])
    bitwise = params[:team][:bit_wise]
    params[:team].delete(:bit_wise)
    @team.bitwise_games_played = 0
    bitwise.each do |b|
		@team.bitwise_games_played |= b.to_i
	end
	@team.save!
    respond_to do |format|
      if @team.update_attributes(params[:team])
        flash[:notice] = 'Team was successfully updated.'
        format.html { redirect_to(@team) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @team.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /teams/1
  # DELETE /teams/1.xml
  def destroy
    @team = Team.find(params[:id])
    tournament = @team.tournament
    @team.destroy

    respond_to do |format|
      format.html { redirect_to(teams_url+'/?id='+tournament.id.to_s) }
      format.xml  { head :ok }
    end
  end
end
