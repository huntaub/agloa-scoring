class Location < ActiveRecord::Base
  has_many :teams
  has_many :players
  has_many :divisions, :through => :teams
end
