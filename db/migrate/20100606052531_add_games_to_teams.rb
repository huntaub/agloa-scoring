class AddGamesToTeams < ActiveRecord::Migration
  def self.up
    add_column :games, :bitwise_number, :integer
    add_column :games, :category, :string
    add_column :teams, :bitwise_games_played, :integer
  end

  def self.down
    remove_column :games, :bitwise_number
    remove_column :games, :category
    remove_column :teams, :bitwise_games_played
  end
end
