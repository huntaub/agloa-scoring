class Seating < ActiveRecord::Base
  belongs_to :game
  belongs_to :division
  belongs_to :round
  serialize :html
end
