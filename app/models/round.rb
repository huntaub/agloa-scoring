class Round < ActiveRecord::Base
  belongs_to :game
  has_many :scores
  accepts_nested_attributes_for :scores
end
