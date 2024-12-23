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
    ROAD_LENGTH = 50     # Shorter road to better see effects
    NUM_CARS = 30       # Start with fewer cars
    V_MAX = 5
    P_SLOW = 0.2       # Lower randomization for smoother flow
    BOUNDARY_TYPE = 'open'  # Set to open boundary
    ALPHA = 0.8        # Probability of new cars entering
    BETA = 0.4        # Probability of cars leaving
    
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
            
        print("\nSimulation complete. Close the plot window to exit.")
        plt.ioff()
        plt.show(block=True)
        
    except KeyboardInterrupt:
        print('\nSimulation stopped by user')
        plt.close('all')
    except Exception as e:
        print(f"\nError occurred: {e}")
        plt.close('all')