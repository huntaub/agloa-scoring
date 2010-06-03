class CreateTeams < ActiveRecord::Migration
  def self.up
    create_table :teams do |t|
      t.integer :division_id
      t.integer :location_id
      t.string :name

      t.timestamps
    end
  end

  def self.down
    drop_table :teams
  end
end
