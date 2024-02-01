import React, { useState, useEffect } from "react";
import ActionCable from "actioncable";

const ParkedVehicles = () => {
  const [parkedVehicles, setParkedVehicles] = useState([]);

  useEffect(() => {
    // Connect to the WebSocket channel
    const cable = ActionCable.createConsumer("ws://localhost:3000/cable");
    const parkingChannel = cable.subscriptions.create("ParkingChannel", {
      received: handleWebSocket,
    });

    console.log("WebSocket connected");

    return () => {
      // Unsubscribe from the WebSocket channel when the component unmounts
      console.log("WebSocket disconnected");
      cable.subscriptions.remove(parkingChannel);
    };
  }, []);

  const handleWebSocket = (data) => {
    // Handle WebSocket updates
    if (data.action === "park") {
      // Update the state with the new parked vehicle
      setParkedVehicles((prevVehicles) => [
        ...prevVehicles,
        { vehicle_id: data.vehicle_id, slot: data.slot },
      ]);
    }
  };

  return (
    <div>
      <h2>Parked Vehicles</h2>
      <ul>
        {parkedVehicles.map((vehicle) => (
          <li key={vehicle.vehicle_id}>
            Vehicle ID: {vehicle.vehicle_id}, Parked in Slot:{" "}
            {vehicle.slot.distance_from_entry_point_a}
          </li>
        ))}
      </ul>
    </div>
  );
};

export default ParkedVehicles;
