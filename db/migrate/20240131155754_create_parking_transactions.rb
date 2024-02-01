class CreateParkingTransactions < ActiveRecord::Migration[7.1]
  def change
    create_table :parking_transactions do |t|
      t.datetime :entry_time
      t.datetime :exit_time
      t.references :vehicle, null: false, foreign_key: true
      t.references :entry_point, null: false, foreign_key: true
      t.references :parking_slot, null: false, foreign_key: true

      t.timestamps
    end
  end
end
