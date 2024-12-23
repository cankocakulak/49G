import matplotlib.pyplot as plt
import numpy as np

class TrafficVisualization:
    def __init__(self, simulation):
        self.simulation = simulation
        plt.ion()
        
        # Create figure with three subplots to include model type
        self.fig = plt.figure(figsize=(15, 10))
        
        # Add model type indicator
        model_type = "VDR Model" if hasattr(simulation, 'p0_slow') else "Basic NaSch Model"
        self.fig.suptitle(f'Traffic Simulation - {model_type}', fontsize=12)
        
        # Setup subplots
        self.ax1 = self.fig.add_subplot(211)  # Traffic flow
        self.ax2 = self.fig.add_subplot(212)  # Density profile
        
        # Initialize history trackers
        self.density_history = []
        self.average_velocities = []
        
        # Setup road plot
        self.ax1.set_xlim(-1, simulation.road_length)
        self.ax1.set_ylim(-0.5, 1.5)
        self.ax1.set_title('Traffic Flow')
        self.ax1.set_yticks([])
        
        # Draw the road line
        self.ax1.axhline(y=0.5, color='black', linestyle='-', linewidth=1)
        
        # Initialize empty scatter plot for cars
        self.scatter = self.ax1.scatter([], [], c=[], cmap='RdYlGn', 
                                      s=100, vmin=0, vmax=simulation.max_velocity)
        plt.colorbar(self.scatter, ax=self.ax1, label='Velocity')
        
        # Setup density profile plot
        self.window_size = 10
        self.num_sections = simulation.road_length // self.window_size
        self.density_line, = self.ax2.plot([], [], 'b-', label='Current Density')
        self.avg_density_line, = self.ax2.plot([], [], 'r--', label='Average Density')
        self.ax2.set_xlim(0, simulation.road_length)
        self.ax2.set_ylim(0, 1)
        self.ax2.set_title('Density Profile')
        self.ax2.set_xlabel('Position')
        self.ax2.set_ylabel('Density')
        self.ax2.legend()
        self.ax2.grid(True)
        
        plt.tight_layout()
    
    def update_plot(self, step):
        road, velocities = self.simulation.get_state()
        
        # Update car positions
        car_positions = []
        car_velocities = []
        
        for pos, car_id in enumerate(road):
            if car_id != 0:
                car_positions.append(pos)
                car_velocities.append(velocities[car_id])
        
        # Update scatter plot
        if car_positions:
            self.scatter.set_offsets(np.column_stack((car_positions, [0.5] * len(car_positions))))
            self.scatter.set_array(np.array(car_velocities))
            # Calculate and store average velocity
            avg_velocity = sum(car_velocities) / len(car_velocities)
            self.average_velocities.append(avg_velocity)
        else:
            self.scatter.set_offsets(np.empty((0, 2)))
            self.scatter.set_array(np.array([]))
            self.average_velocities.append(0)
        
        # Update density profile
        density_profile = self.simulation.get_density_profile(self.window_size)
        self.density_history.append(density_profile)
        
        # Plot current density profile
        x = np.linspace(0, self.simulation.road_length, len(density_profile))
        self.density_line.set_data(x, density_profile)
        
        # Plot average density profile
        if len(self.density_history) > 0:
            avg_profile = np.mean(self.density_history[-50:], axis=0)
            self.avg_density_line.set_data(x, avg_profile)
        
        self.ax1.set_title(f'Traffic Flow (Step {step})')
        plt.pause(0.1)  # Increased pause time to make movement more visible