from traffic_simulation import BaseTrafficSimulation, VDRTrafficSimulation
from traffic_visualization import TrafficVisualization
import matplotlib.pyplot as plt
import numpy as np

def create_simulation(model_type='basic'):
    """Factory function to create the appropriate simulation type"""
    
    # Common parameters
    ROAD_LENGTH = 100
    NUM_CARS = 50
    V_MAX = 5
    P_SLOW = 0.2
    BOUNDARY_TYPE = 'open'
    ALPHA = 0.3
    BETA = 0.3
    
    if model_type == 'vdr':
        P0_SLOW = 0.6  # VDR specific parameter
        return VDRTrafficSimulation(
            road_length=ROAD_LENGTH,
            num_cars=NUM_CARS,
            max_velocity=V_MAX,
            p_slow=P_SLOW,
            p0_slow=P0_SLOW,
            boundary_type=BOUNDARY_TYPE,
            alpha=ALPHA,
            beta=BETA
        )
    else:
        return BaseTrafficSimulation(
            road_length=ROAD_LENGTH,
            num_cars=NUM_CARS,
            max_velocity=V_MAX,
            p_slow=P_SLOW,
            boundary_type=BOUNDARY_TYPE,
            alpha=ALPHA,
            beta=BETA
        )

def main():
    # Choose model type: 'basic' or 'vdr'
    MODEL_TYPE = 'vdr'  # Change this to switch between models
    
    # Create simulation
    sim = create_simulation(MODEL_TYPE)
    vis = TrafficVisualization(sim)
    
    try:
        for step in range(200):
            sim.update()
            vis.update_plot(step)
            
        print("\nSimulation complete. Close the plot window to exit.")
        plt.ioff()
        plt.show()
        
    except KeyboardInterrupt:
        print('\nSimulation stopped by user')
        plt.close('all')

if __name__ == "__main__":
    main()