from dataclasses import dataclass
import numpy as np
import matplotlib.pyplot as plt
from typing import Dict, List, Tuple

@dataclass
class ModelMetrics:
    """Container for model metrics"""
    flow_rates: List[float] = None
    densities: List[float] = None
    avg_velocities: List[float] = None
    jam_frequencies: List[float] = None
    time_steps: List[int] = None
    density_profiles: List[List[float]] = None
    
    def __post_init__(self):
        """Initialize empty lists"""
        self.flow_rates = []
        self.densities = []
        self.avg_velocities = []
        self.jam_frequencies = []
        self.time_steps = []
        self.density_profiles = []
    
    def get_averages(self) -> Dict[str, float]:
        """Calculate average metrics"""
        return {
            'flow_rate': np.mean(self.flow_rates),
            'density': np.mean(self.densities),
            'velocity': np.mean(self.avg_velocities),
            'jam_frequency': np.mean(self.jam_frequencies)
        }

class TrafficAnalyzer:
    """Analyzes and visualizes traffic simulation data"""
    
    def __init__(self):
        self.metrics = {
            'basic': ModelMetrics(),
            'vdr': ModelMetrics()
        }
        self.plot_colors = {
            'basic': 'skyblue',
            'vdr': 'lightcoral'
        }
    
    def collect_metrics(self, simulation, model_type: str, step: int):
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
            avg_velocity = jam_freq = 0
            
        # Store metrics
        metrics.densities.append(density)
        metrics.flow_rates.append(flow)
        metrics.avg_velocities.append(avg_velocity)
        metrics.jam_frequencies.append(jam_freq)
        metrics.time_steps.append(step)
        metrics.density_profiles.append(simulation.get_density_profile(10))

    def analyze_spatial_patterns(self):
        """Analyze how density varies along the road"""
        plt.figure(figsize=(12, 6))
        
        for model_type in ['basic', 'vdr']:
            # Get the last 50 density profiles
            profiles = np.array(self.metrics[model_type].density_profiles[-50:])
            avg_profile = np.mean(profiles, axis=0)
            
            # Plot spatial density distribution
            x = np.linspace(0, 100, len(avg_profile))
            plt.plot(x, avg_profile, 
                    label=f"{'Basic NaSch' if model_type == 'basic' else 'VDR'}", 
                    color=self.plot_colors[model_type])
        
        self._setup_plot("Spatial Density Distribution", 
                        "Position on Road", "Average Density")
        plt.savefig('spatial_density_comparison.png', dpi=300, bbox_inches='tight')
        plt.close()

    def analyze_traffic_efficiency(self):
        """Analyze and visualize traffic efficiency metrics"""
        fig, (ax1, ax2) = plt.subplots(1, 2, figsize=(15, 6))
        
        efficiency_metrics = self._calculate_efficiency_metrics()
        self._plot_efficiency_ratio(ax1, efficiency_metrics)
        self._plot_flow_characteristics(ax2, efficiency_metrics)
        
        plt.tight_layout()
        plt.savefig('traffic_efficiency_analysis.png', dpi=300, bbox_inches='tight')
        plt.close()

    def save_statistics_comparison(self, filename='traffic_stats_comparison.png'):
        """Create and save a bar chart comparing key statistics"""
        metrics_data = self._prepare_comparison_data()
        self._plot_comparison_chart(metrics_data, filename)

    def print_summary_statistics(self):
        """Print summary statistics for both models"""
        for model_type in ['basic', 'vdr']:
            print(f"\n{model_type.upper()} Model Statistics:")
            averages = self.metrics[model_type].get_averages()
            for metric, value in averages.items():
                print(f"Average {metric.replace('_', ' ').title()}: {value:.3f}")

    def _calculate_efficiency_metrics(self) -> Dict[str, Dict[str, float]]:
        """Calculate efficiency metrics for both models"""
        metrics = {}
        for model_type in ['basic', 'vdr']:
            model_metrics = self.metrics[model_type]
            avg_metrics = model_metrics.get_averages()
            
            metrics[model_type] = {
                'flow_density_ratio': avg_metrics['flow_rate'] / avg_metrics['density'],
                'jam_frequency': avg_metrics['jam_frequency'],
                'avg_velocity': avg_metrics['velocity']
            }
        return metrics

    def _plot_efficiency_ratio(self, ax, metrics: Dict):
        """Plot efficiency ratio comparison"""
        ratios = [metrics[model]['flow_density_ratio'] for model in ['basic', 'vdr']]
        ax.bar(['Basic NaSch', 'VDR'], ratios, 
               color=[self.plot_colors['basic'], self.plot_colors['vdr']])
        
        self._setup_subplot(ax, "Traffic Efficiency (Flow/Density Ratio)", 
                          "", "Ratio")
        for i, v in enumerate(ratios):
            ax.text(i, v, f'{v:.2f}', ha='center', va='bottom')

    def _plot_flow_characteristics(self, ax, metrics: Dict):
        """Plot flow characteristics comparison"""
        x = np.arange(2)
        width = 0.35
        
        jam_freq = [metrics[model]['jam_frequency'] for model in ['basic', 'vdr']]
        vel = [metrics[model]['avg_velocity'] for model in ['basic', 'vdr']]
        
        # Add explicit labels to the bars
        ax.bar(x - width/2, jam_freq, width, 
               label='Jam Frequency', color='lightgray')
        ax.bar(x + width/2, vel, width, 
               label='Avg Velocity', color='lightgreen')
        
        ax.set_xticks(x)
        ax.set_xticklabels(['Basic NaSch', 'VDR'])
        ax.set_title("Traffic Flow Characteristics")
        ax.legend(loc='upper right')  # Explicitly set legend location

    def _prepare_comparison_data(self) -> Tuple[List[str], List[float], List[float]]:
        """Prepare data for comparison chart"""
        metrics = ['Flow Rate', 'Density', 'Velocity', 'Jam Frequency']
        basic_values = []
        vdr_values = []
        
        for model_type in ['basic', 'vdr']:
            averages = self.metrics[model_type].get_averages()
            values = [averages[k.lower().replace(' ', '_')] for k in metrics]
            if model_type == 'basic':
                basic_values = values
            else:
                vdr_values = values
                
        return metrics, basic_values, vdr_values

    def _plot_comparison_chart(self, data: Tuple[List[str], List[float], List[float]], 
                             filename: str):
        """Create and save comparison bar chart"""
        metrics, basic_values, vdr_values = data
        
        plt.figure(figsize=(12, 6))
        x = np.arange(len(metrics))
        width = 0.35
        
        plt.bar(x - width/2, basic_values, width, 
                label='Basic NaSch', color=self.plot_colors['basic'])
        plt.bar(x + width/2, vdr_values, width, 
                label='VDR', color=self.plot_colors['vdr'])
        
        self._setup_plot("Traffic Model Comparison: Basic NaSch vs VDR",
                        "Metrics", "Values", x_ticks=(x, metrics))
        
        # Add value labels
        for i, v in enumerate(basic_values):
            plt.text(i - width/2, v, f'{v:.3f}', ha='center', va='bottom')
        for i, v in enumerate(vdr_values):
            plt.text(i + width/2, v, f'{v:.3f}', ha='center', va='bottom')
        
        plt.savefig(filename, dpi=300, bbox_inches='tight')
        print(f"\nStatistics comparison saved as {filename}")
        plt.close()

    @staticmethod
    def _setup_plot(title: str, xlabel: str, ylabel: str, 
                   x_ticks: Tuple[np.ndarray, List[str]] = None):
        """Setup common plot parameters"""
        plt.title(title)
        plt.xlabel(xlabel)
        plt.ylabel(ylabel)
        if x_ticks:
            plt.xticks(*x_ticks)
        plt.legend()
        plt.grid(True, axis='y', linestyle='--', alpha=0.7)

    @staticmethod
    def _setup_subplot(ax, title: str, xlabel: str = "", ylabel: str = "", 
                      labels: List[str] = None):
        """Setup common subplot parameters"""
        ax.set_title(title)
        ax.set_xlabel(xlabel)
        ax.set_ylabel(ylabel)
        if labels:
            ax.set_xticks(np.arange(len(labels)))
            ax.set_xticklabels(labels)
        ax.legend()