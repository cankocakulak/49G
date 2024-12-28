from traffic_simulation import BaseTrafficSimulation, VDRTrafficSimulation, MixedVDRTrafficSimulation
from traffic_visualization import TrafficVisualization
from traffic_analysis import TrafficAnalyzer
import matplotlib.pyplot as plt
import signal
import sys
from dataclasses import dataclass
from typing import Dict, Any

@dataclass
class SimulationConfig:
    """Configuration class for simulation parameters"""
    road_length: int
    num_cars: int
    v_max: int
    p_slow: float
    boundary_type: str
    alpha: float
    beta: float
    p0_slow: float
    steps: int
    truck_ratio: float = 0.2  # Default truck ratio for mixed traffic

class SimulationManager:
    """Manager class to handle simulation creation and execution"""
    
    def __init__(self):
        self.configs = {
            'single': SimulationConfig(
                road_length=50,    # Shorter road for visualization
                num_cars=20,       # Fewer cars for clarity
                v_max=4,
                p_slow=0.5,
                boundary_type='open',
                alpha=0.6,
                beta=0.6,
                p0_slow=0.8,
                steps=200,
                truck_ratio=0.2
            ),
            'comparison': SimulationConfig(
                road_length=200,   # Longer road for statistics
                num_cars=75,
                v_max=4,
                p_slow=0.5,
                boundary_type='open',
                alpha=0.5,
                beta=0.5,
                p0_slow=0.8,
                steps=200,
                truck_ratio=0.2
            )
        }
    
    def create_simulation(self, model_type: str, mode: str) -> BaseTrafficSimulation:
        """Create simulation based on model type and mode"""
        config = self.configs[mode]
        
        if model_type == 'mvdr':
            return MixedVDRTrafficSimulation(
                road_length=config.road_length,
                num_cars=config.num_cars,
                max_velocity=config.v_max,
                p_slow=config.p_slow,
                p0_slow=config.p0_slow,
                boundary_type=config.boundary_type,
                alpha=config.alpha,
                beta=config.beta,
                truck_ratio=config.truck_ratio
            )
        elif model_type == 'vdr':
            return VDRTrafficSimulation(
                road_length=config.road_length,
                num_cars=config.num_cars,
                max_velocity=config.v_max,
                p_slow=config.p_slow,
                p0_slow=config.p0_slow,
                boundary_type=config.boundary_type,
                alpha=config.alpha,
                beta=config.beta
            )
        else:  # basic
            return BaseTrafficSimulation(
                road_length=config.road_length,
                num_cars=config.num_cars,
                max_velocity=config.v_max,
                p_slow=config.p_slow,
                boundary_type=config.boundary_type,
                alpha=config.alpha,
                beta=config.beta
            )
    
    def run_single_simulation(self, model_type: str):
        """Run a single model simulation"""
        sim = self.create_simulation(model_type, 'single')
        self._run_simulation(sim, self.configs['single'].steps)
    
    def run_comparison(self):
        """Run comparison between all models"""
        analyzer = TrafficAnalyzer()
        
        for model_type in ['basic', 'vdr', 'mvdr']:
            print(f"\nRunning {model_type.upper()} model simulation...")
            sim = self.create_simulation(model_type, 'comparison')
            vis = TrafficVisualization(sim)
            
            try:
                self._run_comparison_simulation(sim, vis, analyzer, model_type)
            except KeyboardInterrupt:
                print(f'\n{model_type} simulation stopped by user')
                plt.close('all')
                continue
        
        self._generate_analysis(analyzer)
    
    def _run_simulation(self, sim: BaseTrafficSimulation, steps: int):
        """Run a simulation with visualization"""
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
    
    def _run_comparison_simulation(self, sim: BaseTrafficSimulation, 
                                 vis: TrafficVisualization,
                                 analyzer: TrafficAnalyzer,
                                 model_type: str):
        """Run a single comparison simulation"""
        for step in range(self.configs['comparison'].steps):
            sim.update()
            vis.update_plot(step)
            analyzer.collect_metrics(sim, model_type, step)
    
    def _generate_analysis(self, analyzer: TrafficAnalyzer):
        """Generate all analysis visualizations"""
        analyzer.save_statistics_comparison()
        analyzer.print_summary_statistics()
        analyzer.analyze_spatial_patterns()
        analyzer.analyze_traffic_efficiency()

def signal_handler(sig, frame):
    """Handle graceful exit on CTRL+C"""
    print('\nSimulation stopped gracefully')
    plt.close('all')
    sys.exit(0)

def get_user_input(prompt: str, valid_options: list) -> str:
    """Get and validate user input"""
    while True:
        choice = input(prompt)
        if choice in valid_options:
            return choice
        print(f"Invalid input. Please enter one of: {', '.join(valid_options)}")

def main():
    """Main entry point"""
    signal.signal(signal.SIGINT, signal_handler)
    manager = SimulationManager()
    
    mode = get_user_input(
        "\nChoose simulation mode:\n1. Single simulation\n2. Model comparison\nEnter 1 or 2: ",
        ['1', '2']
    )
    
    if mode == '1':
        model = get_user_input(
            "\nChoose model:\n1. Basic NaSch\n2. VDR\n3. Mixed VDR\nEnter 1, 2, or 3: ",
            ['1', '2', '3']
        )
        model_type = {
            '1': 'basic',
            '2': 'vdr',
            '3': 'mvdr'
        }[model]
        manager.run_single_simulation(model_type)
    else:
        manager.run_comparison()

if __name__ == "__main__":
    main()