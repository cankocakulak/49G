import matplotlib.pyplot as plt
import numpy as np

class VDRVisualization:
    def __init__(self, simulation):
        self.simulation = simulation
        plt.ion()
        
        # Create figure with three subplots
        self.fig = plt.figure(figsize=(15, 10))
        
        # Road state
        self.ax1 = self.fig.add_subplot(311)
        self.ax1.set_title('Traffic State')
        
        # Flow vs Time
        self.ax2 = self.fig.add_subplot(312)
        self.ax2.set_title('Flow vs Time')
        self.ax2.set_xlabel('Time Step')
        self.ax2.set_ylabel('Flow')
        
        # Flow vs Density (Fundamental Diagram)
        self.ax3 = self.fig.add_subplot(313)
        self.ax3.set_title('Flow vs Density (Fundamental Diagram)')
        self.ax3.set_xlabel('Density')
        self.ax3.set_ylabel('Flow')
        self.ax3.set_xlim(0, 1)
        self.ax3.set_ylim(0, simulation.max_velocity)
        
        # Initialize scatter plot for cars
        self.scatter = self.ax1.scatter([], [], c=[], cmap='RdYlGn', 
                                      s=100, vmin=0, vmax=simulation.max_velocity)
        
        plt.tight_layout()
        
    def update_plot(self, step):
        road, velocities = self.simulation.get_state()
        
        # Update road state
        self.ax1.clear()
        car_positions = []
        car_velocities = []
        for pos, car_id in enumerate(road):
            if car_id != 0:
                car_positions.append(pos)
                car_velocities.append(velocities[car_id])
        
        if car_positions:
            self.ax1.scatter(car_positions, [0.5] * len(car_positions),
                           c=car_velocities, cmap='RdYlGn', 
                           vmin=0, vmax=self.simulation.max_velocity)
        
        self.ax1.set_xlim(-1, self.simulation.road_length)
        self.ax1.set_ylim(0, 1)
        self.ax1.set_title(f'Traffic State (Step {step})')
        
        # Update flow vs time
        self.ax2.clear()
        self.ax2.plot(self.simulation.flow_history, 'b-')
        self.ax2.set_title('Flow vs Time')
        self.ax2.set_xlabel('Time Step')
        self.ax2.set_ylabel('Flow')
        self.ax2.grid(True)
        
        # Update fundamental diagram
        self.ax3.clear()
        self.ax3.scatter(self.simulation.density_history,
                        self.simulation.flow_history,
                        c=range(len(self.simulation.flow_history)),
                        cmap='viridis', alpha=0.5)
        self.ax3.set_title('Flow vs Density (Fundamental Diagram)')
        self.ax3.set_xlabel('Density')
        self.ax3.set_ylabel('Flow')
        self.ax3.set_xlim(0, 1)
        self.ax3.set_ylim(0, self.simulation.max_velocity)
        self.ax3.grid(True)
        
        plt.tight_layout()
        plt.pause(0.1)