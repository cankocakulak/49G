from traffic_simulation import TrafficSimulation
from traffic_visualization import TrafficVisualization
import time
import matplotlib.pyplot as plt
import signal
import sys

def signal_handler(sig, frame):
    print('\nSimulation stopped gracefully')
    plt.close('all')
    sys.exit(0)

def main():
    # Simulation parameters
    ROAD_LENGTH = 100
    NUM_CARS = 30
    V_MAX = 5
    P_SLOW = 0.3
    SIMULATION_STEPS = 100

    # Create simulation
    sim = TrafficSimulation(ROAD_LENGTH, NUM_CARS, V_MAX, P_SLOW)
    vis = TrafficVisualization(sim)

    # Run simulation
    for step in range(SIMULATION_STEPS):
        sim.update()
        vis.update_plot(step)
        time.sleep(0.1)  # Add small delay to make visualization visible

    # Keep the plot window open
    input("Press Enter to close...")

if __name__ == "__main__":
    # Register signal handler for Ctrl+C
    signal.signal(signal.SIGINT, signal_handler)
    
    # Parameters
    ROAD_LENGTH = 100  # Shorter road length to better see individual cars
    NUM_CARS = 20     # Fewer cars to better see movement
    V_MAX = 5
    P_SLOW = 0.3
    BOUNDARY_TYPE = 'open'  # or 'open'
    ALPHA = 0.3
    BETA = 0.9
    
    # Create simulation
    sim = TrafficSimulation(
        road_length=ROAD_LENGTH,
        num_cars=NUM_CARS,
        max_velocity=V_MAX,
        p_slow=P_SLOW,
        boundary_type=BOUNDARY_TYPE,
        alpha=ALPHA,
        beta=BETA
    )
    
    vis = TrafficVisualization(sim)
    
    # Run simulation with proper exit handling
    try:
        for step in range(200):
            sim.update()
            vis.update_plot(step)
            
        # Keep the plot window open until manually closed
        print("\nSimulation complete. Close the plot window to exit.")
        plt.ioff()
        plt.show(block=True)
        
    except Exception as e:
        print(f"\nError occurred: {e}")
        plt.close('all')
        sys.exit(1)