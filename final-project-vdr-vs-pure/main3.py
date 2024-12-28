from traffic_simulation import BaseTrafficSimulation, VDRTrafficSimulation
from traffic_visualization import TrafficVisualization
from traffic_analysis import TrafficAnalyzer
import matplotlib.pyplot as plt
import signal
import sys

# Global simulation parameters
SIMULATION_PARAMS = {
    'single': {  # Parameters for single simulation
        'road_length': 50,    # Shorter road to better see effects
        'num_cars': 20,       # Fewer cars for clearer visualization
        'v_max': 4,
        'p_slow': 0.5,       # Lower randomization for smoother flow
        'boundary_type': 'open',
        'alpha': 0.6,        # Probability of new cars entering
        'beta': 0.6,         # Probability of cars leaving
        'p0_slow': 0.8,      # For VDR model only
        'steps': 200         # Number of simulation steps
    },
    'comparison': {  # Parameters for comparison runs
        'road_length': 100,   # Longer road for better statistics
        'num_cars': 50,       # More cars for better comparison
        'v_max': 4,
        'p_slow': 0.5,
        'boundary_type': 'open',
        'alpha': 0.5,
        'beta': 0.5,
        'p0_slow': 0.8,
        'steps': 200
    }
}

def signal_handler(sig, frame):
    print('\nSimulation stopped gracefully')
    plt.close('all')
    sys.exit(0)

def create_simulation(model_type='basic', mode='single'):
    """Factory function to create the appropriate simulation type"""
    params = SIMULATION_PARAMS[mode]
    
    if model_type == 'vdr':
        return VDRTrafficSimulation(
            road_length=params['road_length'],
            num_cars=params['num_cars'],
            max_velocity=params['v_max'],
            p_slow=params['p_slow'],
            p0_slow=params['p0_slow'],
            boundary_type=params['boundary_type'],
            alpha=params['alpha'],
            beta=params['beta']
        )
    else:
        return BaseTrafficSimulation(
            road_length=params['road_length'],
            num_cars=params['num_cars'],
            max_velocity=params['v_max'],
            p_slow=params['p_slow'],
            boundary_type=params['boundary_type'],
            alpha=params['alpha'],
            beta=params['beta']
        )

def run_simulation(sim, steps):
    """Run a single simulation with visualization"""
    vis = TrafficVisualization(sim)
    
    try:
        for step in range(steps):
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

def run_single_simulation(model_type='basic'):
    """Run a single model simulation"""
    sim = create_simulation(model_type, 'single')
    run_simulation(sim, SIMULATION_PARAMS['single']['steps'])

def run_comparison():
    """Run both models and compare them"""
    analyzer = TrafficAnalyzer()
    
    for model_type in ['basic', 'vdr']:
        print(f"\nRunning {model_type.upper()} model simulation...")
        sim = create_simulation(model_type, 'comparison')
        vis = TrafficVisualization(sim)
        
        try:
            for step in range(SIMULATION_PARAMS['comparison']['steps']):
                sim.update()
                vis.update_plot(step)
                analyzer.collect_metrics(sim, model_type, step)
                
        except KeyboardInterrupt:
            print(f'\n{model_type} simulation stopped by user')
            plt.close('all')
            continue
    
    # Generate and save all visualizations
    analyzer.save_statistics_comparison()
    analyzer.print_summary_statistics()
    analyzer.analyze_spatial_patterns()
    analyzer.analyze_traffic_efficiency()

if __name__ == "__main__":
    signal.signal(signal.SIGINT, signal_handler)
    
    while True:
        mode = input("\nChoose simulation mode:\n1. Single simulation\n2. Model comparison\nEnter 1 or 2: ")
        if mode in ['1', '2']:
            break
        print("Invalid input. Please enter 1 or 2.")
    
    if mode == '1':
        while True:
            model = input("\nChoose model:\n1. Basic NaSch\n2. VDR\nEnter 1 or 2: ")
            if model in ['1', '2']:
                break
            print("Invalid input. Please enter 1 or 2.")
        
        run_single_simulation('basic' if model == '1' else 'vdr')
    else:
        run_comparison()