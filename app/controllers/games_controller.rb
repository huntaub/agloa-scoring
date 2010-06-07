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
	    if s.player.team.division == @division
		    if index == 0
		      s.player.totScore = 0
		      @scores << s.player
		    end
		      if (!(s.score.nil?))
		        @scores[@scores.index(s.player)].totScore += s.score
		      end
	    end
	  end
	end
	@scores.sort! { |a,b| b.totScore <=> a.totScore }
	@scores = @scores[0..9]
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
		@teams = Team.find_all_by_tournament_id_and_division_id(@game.tournament.id, @division.id)
		@teams.each {|t| puts t.name}
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
		@teams.each {|t| puts t.name+' score: '+t.teamScore.to_s}
		@teams = @teams[0..2]
		@teams.each_with_index do |item, index|
		  if item.teamScore == 0 || item.teamScore.nil?
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
        if @game.tournament.games.index(@game) == 0
          @game.bitwise_number = 1
        else
          @game.bitwise_number = (@game.tournament.games[@game.tournament.games.index(@game)-1].bitwise_number) * 2
        end
        @game.save!
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
    tournament = @game.tournament
    @game.destroy

    respond_to do |format|
      format.html { redirect_to(tournament) }
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
      if Score.find_by_player_id_and_round_id(p.id, @round.id).nil? && team_plays_game?(p.team, @game)
        @round.scores << Score.new(:player_id => p.id, :player => p, :round => @round, :round_id => @round.id)
      end
    end
  end
  
  def new_round
    Round.create(:game_id => params[:id])
    redirect_to :action => :show, :id => params[:id]
  end
  
  def team_plays_game?(team, game)
    if (team.bitwise_games_played & game.bitwise_number) == game.bitwise_number
      true
    else
      false
    end
  end
  
  def seat
    @currentSeat = Seating.find_by_game_id_and_division_id_and_round_id(params[:id], params[:division], params[:round])
    if @currentSeat.nil? || !(params[:regenerate].nil?)
      @game = Game.find(params[:id])
      @round = Round.find(params[:round])
      @division = Division.find(params[:division])
      if @game.scoringModel == "Table"
        if @game.rounds.index(@round) == 0
       	  ####Random seating
       	  numberOfPlayers = 0
       	  teamsPlaying = []
       	  @division.teams.each do |t|
       	    if team_plays_game?(t, @game)
       	      numberOfPlayers += t.players.length
       	      teamsPlaying << t
       	    end
       	  end
       	  numberOfTables = (numberOfPlayers.to_f/3.to_f).ceil
       	  puts numberOfTables
       	  @tables = Array.new(numberOfTables)
       	  @tables.map! { |x| [] }
       	  teamsPlaying.each do |team|
       	    team.players.each do |player|
       	      playerSeated = false
       	      countOfAttempts = 0
       	      while !playerSeated
	       	      tableToSeat = rand(numberOfTables)
	       	      #puts 'tableToSeat: '+tableToSeat.to_s
	       	      if @tables.at(tableToSeat).length < 3
		       	      anythingWrong = false
		       	      @tables.at(tableToSeat).each do |tablePlayer|
		       	        if player.team == tablePlayer.team
		       	          anythingWrong = true
		       	        end
		       	      end
		       	      if !anythingWrong || countOfAttempts > 10
		       	      	puts 'Seated '+player.name
		       	        playerSeated = true
		       	        @tables.at(tableToSeat).push player
		       	      else
		       	        countOfAttempts += 1
		       	      end
	       	      else
	       	        countOfAttempts += 1
	       	      end
       	      end
       	    end
       	  end       	  
       	  @tables.each_with_index do |p, i| 
       	    puts 'Table ' + i.to_s 
       	    p.each {|a| puts a.name}
       	  end
       	  if @currentSeat.nil?
       	  	@currentSeat = Seating.create(:game_id => @game.id, :html => @tables, :round_id => @round.id, :division_id => @division.id)
       	  else
       	    @currentSeat.html = @tables
       	    @currentSeat.save!
       	  end
        end
        render 'table'
      end
    else
      @game = Game.find(params[:id])
      @round = Round.find(params[:round])
      @division = Division.find(params[:division])
      if @game.scoringModel == "Table"
        @tables = @currentSeat.html
        render 'table'
      end
    end
  end
end