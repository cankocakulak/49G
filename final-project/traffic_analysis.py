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
                'time_steps': []
            },
            'vdr': {
                'flow_rates': [],
                'densities': [],
                'avg_velocities': [],
                'jam_frequencies': [],
                'time_steps': []
            }
        }
    
    def collect_metrics(self, simulation, model_type, step):
        """Collect metrics for each time step"""
        metrics = self.metrics[model_type]
        
        # Calculate current metrics
        density = simulation.get_current_density()
        flow = simulation.get_current_flow()
        
        # Calculate average velocity
        if simulation.velocities:
            avg_velocity = sum(simulation.velocities.values()) / len(simulation.velocities)
        else:
            avg_velocity = 0
            
        # Calculate jam frequency (vehicles with v=0)
        jam_count = sum(1 for v in simulation.velocities.values() if v == 0)
        jam_freq = jam_count / len(simulation.velocities) if simulation.velocities else 0
        
        # Store metrics
        metrics['densities'].append(density)
        metrics['flow_rates'].append(flow)
        metrics['avg_velocities'].append(avg_velocity)
        metrics['jam_frequencies'].append(jam_freq)
        metrics['time_steps'].append(step)
    
    def plot_comparison(self):
        """Generate comparative plots"""
        fig = plt.figure(figsize=(15, 10))
        
        # 1. Flow vs Density (Fundamental Diagram)
        ax1 = fig.add_subplot(221)
        ax1.scatter(self.metrics['basic']['densities'], 
                   self.metrics['basic']['flow_rates'],
                   alpha=0.5, label='Basic NaSch')
        ax1.scatter(self.metrics['vdr']['densities'], 
                   self.metrics['vdr']['flow_rates'],
                   alpha=0.5, label='VDR')
        ax1.set_xlabel('Density')
        ax1.set_ylabel('Flow Rate')
        ax1.set_title('Fundamental Diagram')
        ax1.legend()
        ax1.grid(True)
        
        # 2. Average Velocity over Time
        ax2 = fig.add_subplot(222)
        ax2.plot(self.metrics['basic']['time_steps'],
                self.metrics['basic']['avg_velocities'],
                label='Basic NaSch')
        ax2.plot(self.metrics['vdr']['time_steps'],
                self.metrics['vdr']['avg_velocities'],
                label='VDR')
        ax2.set_xlabel('Time Step')
        ax2.set_ylabel('Average Velocity')
        ax2.set_title('Average Velocity Comparison')
        ax2.legend()
        ax2.grid(True)
        
        # 3. Jam Frequency over Time
        ax3 = fig.add_subplot(223)
        ax3.plot(self.metrics['basic']['time_steps'],
                self.metrics['basic']['jam_frequencies'],
                label='Basic NaSch')
        ax3.plot(self.metrics['vdr']['time_steps'],
                self.metrics['vdr']['jam_frequencies'],
                label='VDR')
        ax3.set_xlabel('Time Step')
        ax3.set_ylabel('Jam Frequency')
        ax3.set_title('Traffic Jam Comparison')
        ax3.legend()
        ax3.grid(True)
        
        # 4. Density Distribution
        ax4 = fig.add_subplot(224)
        ax4.hist(self.metrics['basic']['densities'], 
                alpha=0.5, label='Basic NaSch', bins=20)
        ax4.hist(self.metrics['vdr']['densities'], 
                alpha=0.5, label='VDR', bins=20)
        ax4.set_xlabel('Density')
        ax4.set_ylabel('Frequency')
        ax4.set_title('Density Distribution')
        ax4.legend()
        ax4.grid(True)
        
        plt.tight_layout()
        plt.show()
        
    def print_summary_statistics(self):
        """Print summary statistics for both models"""
        for model in ['basic', 'vdr']:
            print(f"\n{model.upper()} Model Statistics:")
            metrics = self.metrics[model]
            print(f"Average Flow Rate: {np.mean(metrics['flow_rates']):.3f}")
            print(f"Average Density: {np.mean(metrics['densities']):.3f}")
            print(f"Average Velocity: {np.mean(metrics['avg_velocities']):.3f}")
            print(f"Average Jam Frequency: {np.mean(metrics['jam_frequencies']):.3f}")
    
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

        # Create comparison bar chart
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

        # Add value labels on top of bars
        for i, v in enumerate(basic_values):
            plt.text(i - width/2, v, f'{v:.3f}', ha='center', va='bottom')
        for i, v in enumerate(vdr_values):
            plt.text(i + width/2, v, f'{v:.3f}', ha='center', va='bottom')

        plt.grid(True, axis='y', linestyle='--', alpha=0.7)
        plt.tight_layout()
        
        # Save the plot
        plt.savefig(filename, dpi=300, bbox_inches='tight')
        print(f"\nStatistics comparison saved as {filename}")
        plt.close()