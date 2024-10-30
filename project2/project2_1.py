import numpy as np
import matplotlib.pyplot as plt
from scipy.special import erfc
import time

# Set Parameters
sim_params = {
    'rx_center': np.array([0, 0, 0]),
    'rx_r_inMicroMeters': 5,
    'rx_tx_distance': 5,
    'D_inMicroMeterSqrPerSecond': 100,
    'tend': 0.4,
    'delta_t': 0.0001,
    'num_molecules': 50000
}
sim_params['tx_emission_pt'] = sim_params['rx_center'] + np.array([sim_params['rx_tx_distance'] + sim_params['rx_r_inMicroMeters'], 0, 0])

# Simulate Gaussian Random Walk
def simulate_diffusion(params):
    rx_center = np.array(params['rx_center'], dtype=np.float64)
    rx_radius_sq = params['rx_r_inMicroMeters'] ** 2
    tx_emission_pt = np.array(params['tx_emission_pt'], dtype=np.float64)
    D = params['D_inMicroMeterSqrPerSecond']
    delta_t = params['delta_t']
    num_molecules = params['num_molecules']
    num_steps = int(params['tend'] / delta_t)

    # Standard deviation of the step size for Brownian motion
    sigma = np.sqrt(2 * D * delta_t)

    # Initialize molecules at the transmitter position
    mol_positions = np.tile(tx_emission_pt, (num_molecules, 1)).astype(np.float64)
    nRx_timeline = np.zeros(num_steps)  # Track absorption per step

    # Simulate Brownian motion over time steps
    for step in range(num_steps):
        # Generate random displacements (Gaussian noise)
        displacements = np.random.normal(0, sigma, size=mol_positions.shape)
        mol_positions += displacements  # Update positions

        # Calculate squared distances from receiver center
        distances_sq = np.sum((mol_positions - rx_center) ** 2, axis=1)

        # Find molecules that hit the receiver
        hit_mask = distances_sq <= rx_radius_sq
        nRx_timeline[step] = np.sum(hit_mask)

        # Keep only molecules that did not hit the receiver
        mol_positions = mol_positions[~hit_mask]

    time_steps = np.arange(delta_t, params['tend'] + delta_t, delta_t)
    return nRx_timeline, time_steps

# Evaluate Theoretical Formula
def eval_theoretical_nrx(params, time_steps):
    dist = params['rx_tx_distance']
    rx_radius = params['rx_r_inMicroMeters']
    D = params['D_inMicroMeterSqrPerSecond']

    part1 = rx_radius / (dist + rx_radius)
    nrx_cumulative = part1 * erfc(dist / np.sqrt(4 * D * time_steps))

    # Convert cumulative to stepwise by subtracting shifted cumulative values
    nrx_stepwise = np.diff(nrx_cumulative, prepend=0)
    return nrx_stepwise

# Helper function to merge timelines
def merge_timeline(merge_cnt, timeline, time):
    new_size = len(timeline) // merge_cnt
    timeline_merged = np.sum(timeline[:new_size * merge_cnt].reshape(-1, merge_cnt), axis=1)
    time_merged = time[:new_size * merge_cnt].reshape(-1, merge_cnt).mean(axis=1)
    return timeline_merged, time_merged

# Run the Simulation
print("Simulation [START]")
start_time = time.time()
nRx_sim, time_sim = simulate_diffusion(sim_params)
print(f"Simulation [END] Duration: {time.time() - start_time:.2f} seconds")

# Compute Theoretical Results
print("Theoretical Formula [START]")
start_time = time.time()
nRx_theory = eval_theoretical_nrx(sim_params, time_sim)
print(f"Theoretical Formula [END] Duration: {time.time() - start_time:.2f} seconds")

# Merge timelines for smoother plotting
merge_cnt = 10
nRx_sim_merged, time_merged = merge_timeline(merge_cnt, nRx_sim, time_sim)
nRx_theory_merged, _ = merge_timeline(merge_cnt, nRx_theory, time_sim)

# Plot the Results
plt.figure(figsize=(8, 5))
plt.plot(time_merged, nRx_sim_merged / sim_params['num_molecules'], '-', linewidth=2, label='Simulation')
plt.plot(time_merged, nRx_theory_merged, '--', linewidth=2, label='Theory')
plt.xlabel('Time (s)')
plt.ylabel('Average Fraction of Received Molecules')
plt.legend()
plt.grid(True)
plt.title(f'Delta t={merge_cnt * sim_params["delta_t"]}; r_rx={sim_params["rx_r_inMicroMeters"]}; '
          f'dist={sim_params["rx_tx_distance"]}; D={sim_params["D_inMicroMeterSqrPerSecond"]}')
plt.savefig('simulation_plot.png')
print('Plot saved as simulation_plot.png')
plt.show()
