import numpy as np
import matplotlib.pyplot as plt

class TrafficAnalyzer:
    def __init__(self):
        self.metrics = {
            'basic': {
                'flow_rates': [],
                'densities': [],
                'avg_velocities': [],
                'jam_frequencies': [],
                'time_steps': [],
                'density_profiles': []
            },
            'vdr': {
                'flow_rates': [],
                'densities': [],
                'avg_velocities': [],
                'jam_frequencies': [],
                'time_steps': [],
                'density_profiles': []
            }
        }
    
    def collect_metrics(self, simulation, model_type, step):
        """Collect metrics for each time step"""
        metrics = self.metrics[model_type]
        
        # Calculate current metrics
        density = simulation.get_current_density()
        flow = simulation.get_current_flow()
        
        if simulation.velocities:
            avg_velocity = sum(simulation.velocities.values()) / len(simulation.velocities)
            jam_count = sum(1 for v in simulation.velocities.values() if v == 0)
            jam_freq = jam_count / len(simulation.velocities)
        else:
            avg_velocity = 0
            jam_freq = 0
            
        # Store metrics
        metrics['densities'].append(density)
        metrics['flow_rates'].append(flow)
        metrics['avg_velocities'].append(avg_velocity)
        metrics['jam_frequencies'].append(jam_freq)
        metrics['time_steps'].append(step)
        
        # Store density profile
        density_profile = simulation.get_density_profile(10)  # window size of 10
        metrics['density_profiles'].append(density_profile)

    def analyze_spatial_patterns(self):
        """Analyze how density varies along the road"""
        plt.figure(figsize=(12, 6))
        
        # Get the last 50 density profiles for each model
        basic_profiles = np.array(self.metrics['basic']['density_profiles'][-50:])
        vdr_profiles = np.array(self.metrics['vdr']['density_profiles'][-50:])
        
        # Calculate average density profile
        basic_avg = np.mean(basic_profiles, axis=0)
        vdr_avg = np.mean(vdr_profiles, axis=0)
        
        # Plot spatial density distribution
        x = np.linspace(0, 100, len(basic_avg))
        plt.plot(x, basic_avg, label='Basic NaSch', color='skyblue')
        plt.plot(x, vdr_avg, label='VDR', color='lightcoral')
        
        plt.xlabel('Position on Road')
        plt.ylabel('Average Density')
        plt.title('Spatial Density Distribution')
        plt.legend()
        plt.grid(True)
        
        plt.savefig('spatial_density_comparison.png', dpi=300, bbox_inches='tight')
        plt.close()

    def analyze_traffic_efficiency(self):
        """Analyze and visualize traffic efficiency metrics"""
        plt.figure(figsize=(12, 6))
        
        # Calculate efficiency metrics
        metrics = {
            'basic': {
                'flow_density_ratio': np.mean(self.metrics['basic']['flow_rates']) / 
                                    np.mean(self.metrics['basic']['densities']),
                'jam_frequency': np.mean(self.metrics['basic']['jam_frequencies']),
                'avg_velocity': np.mean(self.metrics['basic']['avg_velocities'])
            },
            'vdr': {
                'flow_density_ratio': np.mean(self.metrics['vdr']['flow_rates']) / 
                                    np.mean(self.metrics['vdr']['densities']),
                'jam_frequency': np.mean(self.metrics['vdr']['jam_frequencies']),
                'avg_velocity': np.mean(self.metrics['vdr']['avg_velocities'])
            }
        }
        
        # Create subplots
        fig, (ax1, ax2) = plt.subplots(1, 2, figsize=(15, 6))
        
        # Plot 1: Flow/Density Ratio (Traffic Efficiency)
        ratios = [metrics['basic']['flow_density_ratio'], metrics['vdr']['flow_density_ratio']]
        ax1.bar(['Basic NaSch', 'VDR'], ratios, color=['skyblue', 'lightcoral'])
        ax1.set_title('Traffic Efficiency (Flow/Density Ratio)')
        ax1.set_ylabel('Ratio')
        for i, v in enumerate(ratios):
            ax1.text(i, v, f'{v:.2f}', ha='center', va='bottom')
        
        # Plot 2: Jam Duration Analysis
        x = np.arange(2)
        width = 0.35
        
        jam_freq = [metrics['basic']['jam_frequency'], metrics['vdr']['jam_frequency']]
        vel = [metrics['basic']['avg_velocity'], metrics['vdr']['avg_velocity']]
        
        ax2.bar(x - width/2, jam_freq, width, label='Jam Frequency', color='lightgray')
        ax2.bar(x + width/2, vel, width, label='Avg Velocity', color='lightgreen')
        
        ax2.set_xticks(x)
        ax2.set_xticklabels(['Basic NaSch', 'VDR'])
        ax2.set_title('Traffic Flow Characteristics')
        ax2.legend()
        
        for i, v in enumerate(jam_freq):
            ax2.text(i - width/2, v, f'{v:.2f}', ha='center', va='bottom')
        for i, v in enumerate(vel):
            ax2.text(i + width/2, v, f'{v:.2f}', ha='center', va='bottom')
        
        plt.tight_layout()
        plt.savefig('traffic_efficiency_analysis.png', dpi=300, bbox_inches='tight')
        plt.close()

    def save_statistics_comparison(self, filename='traffic_stats_comparison.png'):
        """Create and save a bar chart comparing key statistics"""
        metrics = ['Flow Rate', 'Density', 'Velocity', 'Jam Frequency']
        basic_values = [
            np.mean(self.metrics['basic']['flow_rates']),
            np.mean(self.metrics['basic']['densities']),
            np.mean(self.metrics['basic']['avg_velocities']),
            np.mean(self.metrics['basic']['jam_frequencies'])
        ]
        vdr_values = [
            np.mean(self.metrics['vdr']['flow_rates']),
            np.mean(self.metrics['vdr']['densities']),
            np.mean(self.metrics['vdr']['avg_velocities']),
            np.mean(self.metrics['vdr']['jam_frequencies'])
        ]

        plt.figure(figsize=(12, 6))
        x = np.arange(len(metrics))
        width = 0.35

        plt.bar(x - width/2, basic_values, width, label='Basic NaSch', color='skyblue')
        plt.bar(x + width/2, vdr_values, width, label='VDR', color='lightcoral')

        plt.xlabel('Metrics')
        plt.ylabel('Values')
        plt.title('Traffic Model Comparison: Basic NaSch vs VDR')
        plt.xticks(x, metrics)
        plt.legend()

        for i, v in enumerate(basic_values):
            plt.text(i - width/2, v, f'{v:.3f}', ha='center', va='bottom')
        for i, v in enumerate(vdr_values):
            plt.text(i + width/2, v, f'{v:.3f}', ha='center', va='bottom')

        plt.grid(True, axis='y', linestyle='--', alpha=0.7)
        plt.tight_layout()
        plt.savefig(filename, dpi=300, bbox_inches='tight')
        print(f"\nStatistics comparison saved as {filename}")
        plt.close()

    def print_summary_statistics(self):
        """Print summary statistics for both models"""
        for model in ['basic', 'vdr']:
            print(f"\n{model.upper()} Model Statistics:")
            metrics = self.metrics[model]
            print(f"Average Flow Rate: {np.mean(metrics['flow_rates']):.3f}")
            print(f"Average Density: {np.mean(metrics['densities']):.3f}")
            print(f"Average Velocity: {np.mean(metrics['avg_velocities']):.3f}")
            print(f"Average Jam Frequency: {np.mean(metrics['jam_frequencies']):.3f}")