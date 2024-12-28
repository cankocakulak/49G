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
            'vdr': ModelMetrics(),
            'mvdr': ModelMetrics()
        }
        self.plot_colors = {
            'basic': 'skyblue',
            'vdr': 'lightcoral',
            'mvdr': 'lightgreen'
        }
        self.model_names = {
            'basic': 'Basic NaSch',
            'vdr': 'VDR',
            'mvdr': 'Mixed VDR'
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
        
        for model_type in self.metrics.keys():
            # Get the last 50 density profiles
            profiles = np.array(self.metrics[model_type].density_profiles[-50:])
            avg_profile = np.mean(profiles, axis=0)
            
            # Plot spatial density distribution
            x = np.linspace(0, 100, len(avg_profile))
            plt.plot(x, avg_profile, 
                    label=self.model_names[model_type], 
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
        """Print summary statistics for all models"""
        for model_type in self.metrics.keys():
            print(f"\n{self.model_names[model_type]} Model Statistics:")
            averages = self.metrics[model_type].get_averages()
            for metric, value in averages.items():
                print(f"Average {metric.replace('_', ' ').title()}: {value:.3f}")

    def _calculate_efficiency_metrics(self) -> Dict:
        """Calculate efficiency metrics for all models"""
        metrics = {}
        for model_type in ['basic', 'vdr', 'mvdr']:
            averages = self.metrics[model_type].get_averages()
            metrics[model_type] = {
                'flow_rate': averages['flow_rate'],
                'density': averages['density'],
                'avg_velocity': averages['velocity'],
                'jam_frequency': averages['jam_frequency']
            }
        return metrics

    def _plot_efficiency_ratio(self, ax, metrics: Dict):
        """Plot efficiency ratio comparison"""
        ratios = []
        for model in ['basic', 'vdr', 'mvdr']:
            if metrics[model]['density'] > 0:  # Avoid division by zero
                ratio = metrics[model]['flow_rate'] / metrics[model]['density']
            else:
                ratio = 0
            ratios.append(ratio)
        
        bars = ax.bar(range(3), ratios, 
                     color=[self.plot_colors[m] for m in ['basic', 'vdr', 'mvdr']])
        
        # Add explicit labels
        for model, bar in zip(['basic', 'vdr', 'mvdr'], bars):
            bar.set_label(self.model_names[model])
        
        ax.set_xticks(range(3))
        ax.set_xticklabels([self.model_names[m] for m in ['basic', 'vdr', 'mvdr']])
        ax.set_title("Traffic Efficiency (Flow/Density Ratio)")
        ax.legend()

        # Add value labels
        for bar in bars:
            height = bar.get_height()
            ax.text(bar.get_x() + bar.get_width()/2, height,
                   f'{height:.2f}', ha='center', va='bottom')

    def _plot_flow_characteristics(self, ax, metrics: Dict):
        """Plot flow characteristics comparison"""
        x = np.arange(3)
        width = 0.35
        
        # Get data for all models
        jam_freq = [metrics[m]['jam_frequency'] for m in ['basic', 'vdr', 'mvdr']]
        vel = [metrics[m]['avg_velocity'] for m in ['basic', 'vdr', 'mvdr']]
        
        # Create bars with labels
        bars1 = ax.bar(x - width/2, jam_freq, width, label='Jam Frequency', color='lightgray')
        bars2 = ax.bar(x + width/2, vel, width, label='Avg Velocity', color='lightgreen')
        
        ax.set_xticks(x)
        ax.set_xticklabels([self.model_names[m] for m in ['basic', 'vdr', 'mvdr']])
        ax.set_title("Traffic Flow Characteristics")
        ax.legend()
        
        # Add value labels
        for bars in [bars1, bars2]:
            for bar in bars:
                height = bar.get_height()
                ax.text(bar.get_x() + bar.get_width()/2, height,
                       f'{height:.2f}', ha='center', va='bottom')

    def _prepare_comparison_data(self) -> Tuple[List[str], List[float], List[float], List[float]]:
        """Prepare data for comparison chart"""
        metrics = ['Flow Rate', 'Density', 'Velocity', 'Jam Frequency']
        model_values = {}
        
        for model_type in ['basic', 'vdr', 'mvdr']:
            averages = self.metrics[model_type].get_averages()
            model_values[model_type] = [
                averages['flow_rate'],
                averages['density'],
                averages['velocity'],
                averages['jam_frequency']
            ]
        
        return metrics, model_values['basic'], model_values['vdr'], model_values['mvdr']

    def _plot_comparison_chart(self, data: Tuple[List[str], List[float], List[float], List[float]], 
                             filename: str):
        """Create and save comparison bar chart"""
        metrics, basic_values, vdr_values, mvdr_values = data
        
        plt.figure(figsize=(12, 6))
        x = np.arange(len(metrics))
        width = 0.25  # Narrower bars to fit three models
        
        # Plot bars for each model
        plt.bar(x - width, basic_values, width, 
                label=self.model_names['basic'], color=self.plot_colors['basic'])
        plt.bar(x, vdr_values, width, 
                label=self.model_names['vdr'], color=self.plot_colors['vdr'])
        plt.bar(x + width, mvdr_values, width, 
                label=self.model_names['mvdr'], color=self.plot_colors['mvdr'])
        
        self._setup_plot("Traffic Model Comparison",
                        "Metrics", "Values", x_ticks=(x, metrics))
        
        # Add value labels
        for i, v in enumerate(basic_values):
            plt.text(i - width, v, f'{v:.3f}', ha='center', va='bottom')
        for i, v in enumerate(vdr_values):
            plt.text(i, v, f'{v:.3f}', ha='center', va='bottom')
        for i, v in enumerate(mvdr_values):
            plt.text(i + width, v, f'{v:.3f}', ha='center', va='bottom')
        
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