class CreateSeatings < ActiveRecord::Migration
  def self.up
    create_table :seatings do |t|
      t.integer :game_id
      t.integer :round_id
      t.integer :division_id
      t.text :html

      t.timestamps
    end
  end

  def self.down
    drop_table :seatings
  end
end
