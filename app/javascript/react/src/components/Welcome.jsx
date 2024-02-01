import React, { useEffect, useState } from "react";
import ReactDOM from "react-dom/client";
import ParkedVehicles from "./ParkedVehicles";

const Welcome = () => {
  const [vehicleSize, setVehicleSize] = useState("small");
  const [entryPoint, setEntryPoint] = useState("A");
  const [vehicleId, setVehicleId] = useState(null);
  const [parkedVehicles, setParkedVehicles] = useState([]);

  useEffect(() => {
    fetch("/parking") // Assuming you have a route to retrieve parked vehicles
      .then((response) => response.json())
      .then((data) => setParkedVehicles(data.parked_vehicles))
      .catch((error) =>
        console.error("Error fetching parked vehicles:", error)
      );
  }, [vehicleId]);

  useEffect(() => {
    console.log(parkedVehicles);
  }, [parkedVehicles]);

  const handlePark = async () => {
    try {
      const csrfToken = document.querySelector(
        'meta[name="csrf-token"]'
      ).content;

      const response = await fetch("/park", {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
          "X-CSRF-Token": csrfToken, // Include the CSRF token in the headers
        },
        body: JSON.stringify({
          vehicle_size: vehicleSize,
          entry_point: entryPoint,
        }),
      });

      const data = await response.json();
      setVehicleId(data.vehicle_id);
      alert("Vehicle parked successfully!");
    } catch (error) {
      console.error("Error parking vehicle:", error);
    }
  };

  const handleUnpark = async () => {
    try {
      const csrfToken = document.querySelector(
        'meta[name="csrf-token"]'
      ).content;

      const response = await fetch("/unpark", {
        method: "POST", // Or use 'PATCH' or 'DELETE' depending on your route definition
        headers: {
          "Content-Type": "application/json",
          "X-CSRF-Token": csrfToken,
        },
        body: JSON.stringify({ vehicle_id: vehicleId }),
      });

      const data = await response.json();
      // Handle the response data as needed

      alert("Vehicle unparked successfully!");
    } catch (error) {
      console.error("Error unparking vehicle:", error);
    }
  };

  return (
    <div>
      <h2>Parking Form</h2>
      <label>
        Vehicle Size:
        <select
          value={vehicleSize}
          onChange={(e) => setVehicleSize(e.target.value)}
        >
          <option value="small">Small</option>
          <option value="medium">Medium</option>
          <option value="large">Large</option>
        </select>
      </label>
      <br />
      <label>
        Entry Point:
        <select
          value={entryPoint}
          onChange={(e) => setEntryPoint(e.target.value)}
        >
          <option value="A">A</option>
          <option value="B">B</option>
          <option value="C">C</option>
        </select>
      </label>
      <br />
      <button onClick={handlePark}>Park</button>
      <button onClick={handleUnpark} disabled={!vehicleId}>
        Unpark
      </button>
      <ParkedVehicles />
      {/* <div>
        <h2>Parked Vehicles</h2>
        <ul>
          {parkedVehicles &&
            parkedVehicles.map((vehicle) => (
              <li key={vehicle.vehicle_id}>
                Vehicle ID: {vehicle.vehicle_id}, Parked in Slot:{" "}
                {vehicle.slot.distance_from_entry_point_a}
              </li>
            ))}
        </ul>
      </div> */}
    </div>
  );
};

const root = ReactDOM.createRoot(document.getElementById("welcome"));

root.render(
  <React.StrictMode>
    {" "}
    <Welcome />
  </React.StrictMode>
);

// document.addEventListener("DOMContentLoaded", () => {
//   ReactDOM.render(<Welcome />, document.getElementById("welcome"));
// });

export default Welcome;
