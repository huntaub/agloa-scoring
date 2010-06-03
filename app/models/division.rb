class Division < ActiveRecord::Base
  has_many :teams
  has_many :players
  has_many :locations, :through => :teams
end
