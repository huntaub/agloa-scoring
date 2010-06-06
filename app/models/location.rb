class Location < ActiveRecord::Base
  has_many :teams, :dependent => :destroy
  has_many :players, :dependent => :destroy
  has_many :divisions, :through => :teams
end
