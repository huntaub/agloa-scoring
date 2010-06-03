class Player < ActiveRecord::Base
  belongs_to :team
  belongs_to :division
  belongs_to :location
end
