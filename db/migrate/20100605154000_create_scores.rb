class CreateScores < ActiveRecord::Migration
  def self.up
    create_table :scores do |t|
      t.integer :score
      t.integer :player_id
      t.integer :game_id

      t.timestamps
    end
  end

  def self.down
    drop_table :scores
  end
end
