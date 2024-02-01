class CreateParkingSlots < ActiveRecord::Migration[7.1]
  def change
    create_table :parking_slots do |t|
      t.integer :distance_from_entry_point_a
      t.integer :distance_from_entry_point_b
      t.integer :distance_from_entry_point_c
      t.integer :size
      t.references :entry_point, null: false, foreign_key: true

      t.timestamps
    end
  end
end
