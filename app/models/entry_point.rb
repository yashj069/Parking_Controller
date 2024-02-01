class EntryPoint < ApplicationRecord
    has_many :parking_slots
  has_many :parking_transactions
end
