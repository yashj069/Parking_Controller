class Vehicle < ApplicationRecord
    has_many :parking_transactions

  enum size: { small: 'small', medium: 'medium', large: 'large' }
end
