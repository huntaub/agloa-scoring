class Player < ActiveRecord::Base
  belongs_to :team
  belongs_to :division
  belongs_to :location
  has_many :scores, :dependent => :destroy
  validates_length_of :players_on_team, :maximum => 4, :message => 'can have a maximum of 5 players'
  
  def players_on_team
    @players = team.players
  end
  
  def tournament
    team.tournament
  end
  
  def rank
    @rank
  end
  
  def rank=(num)
    @rank = num
  end
  
  def totScore
    @tot
  end
  
  def totScore=(num)
    @tot = num
  end
  
  def ==(obj)
    if (obj.id == id)
      true
    else
      false
    end
  end
end