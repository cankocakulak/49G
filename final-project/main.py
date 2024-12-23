from traffic_simulation import TrafficSimulation
from traffic_visualization import TrafficVisualization
import matplotlib.pyplot as plt
import signal
import sys
import time

def signal_handler(sig, frame):
    print('\nSimulation stopped gracefully')
    plt.close('all')
    sys.exit(0)

def main():
    # Register signal handler for Ctrl+C
    signal.signal(signal.SIGINT, signal_handler)
    
    # Simulation parameters
    ROAD_LENGTH = 30     # Shorter road to better see effects
    NUM_CARS = 50       # Start with fewer cars
    V_MAX = 3
    P_SLOW = 0.5       # Randomization probability
    BOUNDARY_TYPE = 'open'  # 'open' or 'closed'
    ALPHA = 0.3        # Probability of new cars entering
    BETA = 0.8         # Probability of cars leaving
    SIMULATION_STEPS = 100
    
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
        for step in range(SIMULATION_STEPS):
            sim.update()
            vis.update_plot(step)
            time.sleep(0.1)  # Add small delay to make visualization visible
            
        print("\nSimulation complete. Close the plot window to exit.")
        plt.ioff()
        plt.show(block=True)
        
    except KeyboardInterrupt:
        print('\nSimulation stopped by user')
        plt.close('all')
    except Exception as e:
        print(f"\nError occurred: {e}")
        plt.close('all')

if __name__ == "__main__":
    main()