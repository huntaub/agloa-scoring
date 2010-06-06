class Round < ActiveRecord::Base
  belongs_to :game
  has_many :scores, :dependent => :destroy
  accepts_nested_attributes_for :scores
  has_many :seatings
end
