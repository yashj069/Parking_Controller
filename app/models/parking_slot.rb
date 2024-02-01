class ParkingSlot < ApplicationRecord
  belongs_to :entry_point
  has_many :parking_transactions

  enum size: { small: 0, medium: 1, large: 2 }
end
