class Division < ActiveRecord::Base
  has_many :teams
  has_many :players, :through => :teams
  has_many :locations, :through => :teams
  belongs_to :tournament
  has_many :seatings
end
