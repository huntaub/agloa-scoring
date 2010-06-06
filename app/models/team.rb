class Team < ActiveRecord::Base
  has_many :players, :dependent => :destroy
  belongs_to :division
  belongs_to :location
  belongs_to :tournament
  attr_protected :bitwise_games_played
  validates_size_of :players, :maximum => 5, :message => 'maximum of %d players'
  
  def teamScore
    @teamScore
  end
  
  def teamScore=(num)
    @teamScore = num
  end
  
  def rank
    @rank
  end
  
  def rank=(num)
    @rank = num
  end
end
