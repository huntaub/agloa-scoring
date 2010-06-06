class AddRoundIdToScore < ActiveRecord::Migration
  def self.up
    remove_column :scores, :game_id
    add_column :scores, :round_id, :integer
  end

  def self.down
    add_column :scores, :game_id, :integer
    remove_column :scores, :round_id
  end
end
