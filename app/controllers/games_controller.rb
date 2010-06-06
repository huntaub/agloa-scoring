class GamesController < ApplicationController
  # GET /games
  # GET /games.xml
  def index
    @games = Game.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @games }
    end
  end

  # GET /games/1
  # GET /games/1.xml
  def show
  	if (params[:division].nil?)
  		@division = Division.first
  	else
  		@division = Division.find(params[:division])
  	end
    @game = Game.find(params[:id])
    @rounds = @game.rounds
	@scores = []
	@superNil = false
	@rounds.each_with_index do |round, index|
	  round.scores.each do |s|
	    if index == 0
	      s.player.totScore = 0
	      @scores << s.player
	    end
	      if (!(s.score.nil?))
	        @scores[@scores.index(s.player)].totScore += s.score
	      end
	  end
	end
	@scores.sort! { |a,b| b.totScore <=> a.totScore }
	@scores = @scores[0..10]
	@scores.each_with_index do |item, index|
	  if !item.totScore.nil?
	  	  @superNil = true
		  if index == 0
		    item.rank = 1
		  else
		    if item.totScore == @scores[(index - 1)].totScore
		      item.rank = @scores[(index - 1)].rank
		    else
		   	  item.rank = (index + 1)
		   	end
		  end
	  else
	    @scores.delete(item)
	  end
	end
	if (@scores.length > 0 && @superNil)
		@teams = Team.find_all_by_tournament_id(@game.tournament.id)
		if (@teams.length > 1)
			@teams.sort! do |a,b|
				count = 0
				a.players.each do |p|
				  if (!@scores.index(p).nil?)
					  if (!@scores[@scores.index(p)].totScore.nil?)
					    count += @scores[@scores.index(p)].totScore 
					  end
				  end
				end
				a.teamScore = count
				count = 0
				b.players.each do |p|
				  if (!@scores.index(p).nil?)
				  	  if (!@scores[@scores.index(p)].totScore.nil?)
				  	    count += @scores[@scores.index(p)].totScore 
				  	  end
				  end
			    end
				b.teamScore = count
				b.teamScore <=> a.teamScore
			end
		end
		@teams = @teams[0..10]
		@teams.each_with_index do |item, index|
		  if item.teamScore == 0
		    @teams.delete(item)
		  else
			  if index == 0
			    item.rank = 1
			  else
			    if item.teamScore == @teams[(index - 1)].teamScore
			      item.rank = @teams[(index - 1)].rank
			    else
			   	  item.rank = (index + 1)
			   	end
			  end
		  end
		end
	end
	
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @game }
    end
  end

  # GET /games/new
  # GET /games/new.xml
  def new
    @game = Game.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @game }
    end
  end

  # GET /games/1/edit
  def edit
    @game = Game.find(params[:id])
  end

  # POST /games
  # POST /games.xml
  def create
    @game = Game.new(params[:game])

    respond_to do |format|
      if @game.save
        flash[:notice] = 'Game was successfully created.'
        format.html { redirect_to(@game) }
        format.xml  { render :xml => @game, :status => :created, :location => @game }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @game.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /games/1
  # PUT /games/1.xml
  def update
    @game = Game.find(params[:id])

    respond_to do |format|
      if @game.update_attributes(params[:game])
        flash[:notice] = 'Game was successfully updated.'
        format.html { redirect_to(@game) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @game.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /games/1
  # DELETE /games/1.xml
  def destroy
    @game = Game.find(params[:id])
    @game.destroy

    respond_to do |format|
      format.html { redirect_to(games_url) }
      format.xml  { head :ok }
    end
  end
  
  def score
  	if (params[:division].nil?)
  		@division = Division.first
  	else
  		@division = Division.find(params[:division])
  	end
  	@round = Round.find(params[:round])
    @game = Game.find(params[:id])
    @players = @division.players
    @players.each do |p|
      if Score.find_by_player_id_and_round_id(p.id, @round.id).nil?
        @round.scores << Score.new(:player_id => p.id, :player => p, :round => @round, :round_id => @round.id)
      end
    end
  end
  
  def new_round
    Round.create(:game_id => params[:id])
    redirect_to :action => :show, :id => params[:id]
  end
end