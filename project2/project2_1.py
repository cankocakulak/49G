import numpy as np
import matplotlib.pyplot as plt
from scipy.special import erfc
import time

#After installing the required packages, run the following code to simulate the diffusion of molecules in a 3D environment with a spherical receiver.
# python project2_1.py

# Define parameter sets
sim_params_1 = {
    'rx_center': np.array([0, 0, 0]),
    'rx_r_inMicroMeters': 5,
    'rx_tx_distance': 5,
    'tx_emission_pt': np.array([10, 0, 0]),
    'D_inMicroMeterSqrPerSecond': 75,
    'tend': 0.4,
    'delta_t': 0.0001,
    'num_molecules': 50000
}

sim_params_2 = sim_params_1.copy()
sim_params_2['D_inMicroMeterSqrPerSecond'] = 200

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
    nrx_cumulative = params['num_molecules'] * part1 * erfc(dist / np.sqrt(4 * D * time_steps))
    return nrx_cumulative

# Run simulations for both parameter sets
print("Simulation 1 (D=75) [START]")
start_time = time.time()
nRx_sim_1, time_sim_1 = simulate_diffusion(sim_params_1)
print(f"Simulation 1 [END] Duration: {time.time() - start_time:.2f} seconds")

print("Simulation 2 (D=200) [START]")
start_time = time.time()
nRx_sim_2, time_sim_2 = simulate_diffusion(sim_params_2)
print(f"Simulation 2 [END] Duration: {time.time() - start_time:.2f} seconds")

# Calculate cumulative sums for simulation results
nRx_sim_cumulative_1 = np.cumsum(nRx_sim_1)
nRx_sim_cumulative_2 = np.cumsum(nRx_sim_2)

# Calculate theoretical results
print("Calculating theoretical results...")
nRx_theory_1 = eval_theoretical_nrx(sim_params_1, time_sim_1)
nRx_theory_2 = eval_theoretical_nrx(sim_params_2, time_sim_2)

# Plot the Results
plt.figure(figsize=(10, 6))

# Plot for D = 75
plt.plot(time_sim_1, nRx_sim_cumulative_1, '-', linewidth=2, label='Simulation (D=75)')
plt.plot(time_sim_1, nRx_theory_1, '--', linewidth=2, label='Theory (D=75)')

# Plot for D = 200
plt.plot(time_sim_2, nRx_sim_cumulative_2, '-', linewidth=2, label='Simulation (D=200)')
plt.plot(time_sim_2, nRx_theory_2, '--', linewidth=2, label='Theory (D=200)')

plt.xlabel('Time (s)')
plt.ylabel('Cumulative Number of Received Molecules')
plt.legend()
plt.grid(True)
plt.title('Cumulative Received Molecules vs Time\n' +
          f'r_rx={sim_params_1["rx_r_inMicroMeters"]}µm, ' +
          f'distance={sim_params_1["rx_tx_distance"]}µm')
plt.savefig('cumulative_simulation_plot.png')
print('Plot saved as cumulative_simulation_plot.png')
plt.show()