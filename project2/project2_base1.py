import numpy as np
import matplotlib.pyplot as plt
from scipy.special import erfc
import time

# Define parameter set
sim_params = {
    'rx_center': np.array([0, 0, 0]),
    'rx_r_inMicroMeters': 5,
    'rx_tx_distance': 5,
    'tx_emission_pt': np.array([10, 0, 0]),
    'D_inMicroMeterSqrPerSecond': 75,
    'tend': 0.4,
    'delta_t': 0.0001,
    'num_molecules': 50000
}

def simulate_diffusion(params):
    rx_center = np.array(params['rx_center'], dtype=np.float64)
    rx_radius_sq = params['rx_r_inMicroMeters'] ** 2
    tx_emission_pt = np.array(params['tx_emission_pt'], dtype=np.float64)
    D = params['D_inMicroMeterSqrPerSecond']
    delta_t = params['delta_t']
    num_molecules = params['num_molecules']
    num_steps = int(params['tend'] / delta_t)

    sigma = np.sqrt(2 * D * delta_t)
    mol_positions = np.tile(tx_emission_pt, (num_molecules, 1)).astype(np.float64)
    nRx_timeline = np.zeros(num_steps)

    for step in range(num_steps):
        displacements = np.random.normal(0, sigma, size=mol_positions.shape)
        mol_positions += displacements

        distances_sq = np.sum((mol_positions - rx_center) ** 2, axis=1)
        hit_mask = distances_sq <= rx_radius_sq
        nRx_timeline[step] = np.sum(hit_mask)
        mol_positions = mol_positions[~hit_mask]

    time_steps = np.arange(delta_t, params['tend'] + delta_t, delta_t)
    return nRx_timeline, time_steps

def eval_theoretical_nrx(params, time_steps):
    dist = params['rx_tx_distance']
    rx_radius = params['rx_r_inMicroMeters']
    D = params['D_inMicroMeterSqrPerSecond']

    part1 = rx_radius / (dist + rx_radius)
    nrx_cumulative = params['num_molecules'] * part1 * erfc(dist / np.sqrt(4 * D * time_steps))
    return nrx_cumulative

# Run simulation
print("Simulation [START]")
nRx_sim, time_sim = simulate_diffusion(sim_params)
print("Simulation [END]")

# Calculate cumulative sum and theoretical results
nRx_sim_cumulative = np.cumsum(nRx_sim)
nRx_theory = eval_theoretical_nrx(sim_params, time_sim)

# Plot results
plt.figure(figsize=(10, 6))
plt.plot(time_sim, nRx_sim_cumulative, '-', linewidth=2, label='Simulation')
plt.plot(time_sim, nRx_theory, '--', linewidth=2, label='Theory')
plt.xlabel('Time (s)')
plt.ylabel('Cumulative Number of Received Molecules')
plt.legend()
plt.grid(True)
plt.title('Cumulative Received Molecules vs Time\n' +
          f'D={sim_params["D_inMicroMeterSqrPerSecond"]}µm²/s, ' +
          f'r_rx={sim_params["rx_r_inMicroMeters"]}µm, ' +
          f'distance={sim_params["rx_tx_distance"]}µm')
plt.savefig('cumulative_simulation_plotforbase.png')
plt.show()