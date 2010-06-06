class Score < ActiveRecord::Base
  belongs_to :player
  belongs_to :round
  
  def rank
    @rank
  end
  
  def rank=(num)
  	@rank = num
  end
end