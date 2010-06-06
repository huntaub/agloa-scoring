class Game < ActiveRecord::Base
  has_many :divisions
  has_many :rounds, :dependent => :destroy
  belongs_to :tournament
  accepts_nested_attributes_for :rounds
end