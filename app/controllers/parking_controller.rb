# app/controllers/parking_controller.rb
class ParkingController < ApplicationController
  before_action :load_entry_point_and_parking_slot, only: [:park]
  before_action :load_parking_transaction, only: [:unpark]

  def park
    vehicle = Vehicle.create(size: params[:vehicle_size])
    # vehicle = Vehicle.create(vehicle_params)

    parking_slot = find_nearest_available_parking_slot

    parking_transaction = ParkingTransaction.create(vehicle: vehicle, entry_point: @entry_point, parking_slot: parking_slot, entry_time: Time.now)

    ActionCable.server.broadcast('parking_channel', { action: 'park', vehicle_id: parking_transaction.vehicle.id, slot: parking_transaction.parking_slot })

    render json: { message: "Vehicle parked successfully.", vehicle_id: parking_transaction.vehicle_id }
  end
    # private

    # def vehicle_params
    #   params.permit(:vehicle_size)
    # end

  def unpark
    return render json: { error: "Vehicle not found or already unparked." }, status: :not_found unless @parking_transaction

    fees = calculate_parking_fees(@parking_transaction)

    @parking_transaction.update(exit_time: Time.now)

    render json: { message: "Vehicle unparked successfully.", fees: fees }
  end

  def index
    @parked_vehicles = ParkingTransaction.includes(:vehicle, :parking_slot)
                                         .where(exit_time: nil)
                                         .map { |transaction| { vehicle_id: transaction.vehicle.id, slot: transaction.parking_slot } }
    puts "Parked Vehicles: #{@parked_vehicles}"
    render json: { parked_vehicles: @parked_vehicles }
  end
  

  private

  def load_entry_point_and_parking_slot
    @entry_point = EntryPoint.find_by(name: params[:entry_point])
    render json: { error: "Invalid entry point." }, status: :unprocessable_entity unless @entry_point
  end

  def load_parking_transaction
    @parking_transaction = ParkingTransaction.find_by(vehicle_id: params[:vehicle_id], exit_time: nil)
  end

  def find_nearest_available_parking_slot
    available_slots = ParkingSlot.where(entry_point: @entry_point, size: Vehicle.sizes[params[:vehicle_size]])
                                 .where.not(id: ParkingTransaction.where(exit_time: nil).pluck(:parking_slot_id))

    available_slots.order(:distance_from_entry_point_a).first
  end

  def load_parked_vehicles
    @parked_vehicles = ParkingTransaction.includes(:vehicle, :parking_slot)
                                       .where(exit_time: nil)
                                       .map { |transaction| { vehicle_id: transaction.vehicle.id, slot: transaction.parking_slot } }
  end

  def calculate_parking_fees(parking_transaction)
    initial_hours = 3
    flat_rate = 40
    exceeding_hourly_rates = {
      small: 20,
      medium: 60,
      large: 100
    }
    full_day_fee = 5000

    entry_time = parking_transaction.entry_time
    exit_time = parking_transaction.exit_time || Time.now

    hours_parked = ((exit_time - entry_time) / 1.hour).ceil

    if hours_parked <= initial_hours
      return flat_rate
    end

    size = Vehicle.sizes[parking_transaction.vehicle.size.to_sym]

    total_fee = flat_rate + (hours_parked - initial_hours) * exceeding_hourly_rates[size]

    # Calculate fees for full days
    full_days = (hours_parked / 24).floor
    total_fee += full_days * full_day_fee

    total_fee
  end
end
