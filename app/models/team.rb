class Team < ActiveRecord::Base
  has_many :players
  belongs_to :division
  belongs_to :location
end
