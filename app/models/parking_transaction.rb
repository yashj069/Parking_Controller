class ParkingTransaction < ApplicationRecord
  belongs_to :vehicle
  belongs_to :entry_point
  belongs_to :parking_slot

  def calculate_parking_fees
    initial_hours = 3
    flat_rate = 40
    exceeding_hourly_rates = {
      small: 20,
      medium: 60,
      large: 100
    }
    full_day_fee = 5000

    entry_time = self.entry_time
    exit_time = self.exit_time || Time.now

    hours_parked = ((exit_time - entry_time) / 1.hour).ceil

    if hours_parked <= initial_hours
      return flat_rate
    end

    size = Vehicle.sizes[self.vehicle.size.to_sym]

    total_fee = flat_rate + (hours_parked - initial_hours) * exceeding_hourly_rates[size]

    # Calculate fees for full days
    full_days = (hours_parked / 24).floor
    total_fee += full_days * full_day_fee

    total_fee
  end
end
