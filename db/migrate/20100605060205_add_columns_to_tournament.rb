class AddColumnsToTournament < ActiveRecord::Migration
  def self.up
    add_column :tournaments, :in_progress, :boolean
  end

  def self.down
    remove_column :tournaments, :in_progress
  end
end
