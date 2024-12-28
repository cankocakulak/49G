import matplotlib.pyplot as plt
from vehicle_types import VehicleType

class TrafficVisualization:
    def __init__(self, simulation):
        self.simulation = simulation
        self.fig, self.ax = plt.subplots(figsize=(15, 3))
        plt.ion()
        
        # Add color mapping for vehicle types
        self.vehicle_colors = {
            VehicleType.CAR: 'blue',
            VehicleType.TRUCK: 'red'
        } if hasattr(simulation, 'vehicle_types') else {'default': 'blue'}
    
    def update_plot(self, step):
        self.ax.clear()
        
        # Plot road
        self.ax.plot([0, self.simulation.road_length], [0, 0], 'k-', linewidth=2)
        
        # Plot vehicles
        for pos, vehicle_id in enumerate(self.simulation.road):
            if vehicle_id == 0:  # Empty cell
                continue
                
            if hasattr(self.simulation, 'vehicle_types'):
                # For mixed traffic simulation
                vehicle_type = self.simulation.vehicle_types[vehicle_id]
                color = self.vehicle_colors[vehicle_type]
                marker = 's' if vehicle_type == VehicleType.TRUCK else 'o'
                size = 100 if vehicle_type == VehicleType.TRUCK else 80
            else:
                # For basic and VDR simulations
                color = 'blue'
                marker = 'o'
                size = 80
            
            self.ax.plot(pos, 0, marker, color=color, markersize=size/10)
        
        # Set plot properties
        self.ax.set_xlim(-1, self.simulation.road_length + 1)
        self.ax.set_ylim(-0.5, 0.5)
        self.ax.set_title(f'Step {step}')
        
        # Add legend for mixed traffic
        if hasattr(self.simulation, 'vehicle_types'):
            self.ax.plot([], [], 'bo', label='Car')
            self.ax.plot([], [], 'rs', label='Truck')
            self.ax.legend()
        
        plt.pause(0.01)