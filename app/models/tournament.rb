class Tournament < ActiveRecord::Base
  has_many :games, :dependent => :destroy
  has_many :divisions
  has_many :teams, :dependent => :destroy
  has_many :players, :through => :teams, :dependent => :destroy
end