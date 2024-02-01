# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

# db/seeds.rb

# Entry Points
entry_points_data = [
  { name: 'A' },
  { name: 'B' },
  { name: 'C' }
]

entry_points_data.each { |data| EntryPoint.create(data) }

puts 'Entry Points seeded successfully.'

# Parking Slots
parking_slots_data = [
  { distance_from_entry_point_a: 1, distance_from_entry_point_b: 4, distance_from_entry_point_c: 5, size: 'small', entry_point: EntryPoint.find_by(name: 'A') },
  # Add more parking slots as needed
]

parking_slots_data.each { |data| ParkingSlot.create(data) }

puts 'Parking Slots seeded successfully.'

# Vehicles
vehicles_data = [
  { size: 'small' },
  { size: 'medium' },
  { size: 'large' }
]

vehicles_data.each { |data| Vehicle.create(data) }

puts 'Vehicles seeded successfully.'
