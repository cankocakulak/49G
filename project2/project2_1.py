import numpy as np
import matplotlib.pyplot as plt
from scipy.special import erfc

def simulate_diffusion(params):
    np.random.seed(42)  # Ensure reproducibility

    # Extract parameters from input
    rx_center = np.array(params['rx_center'], dtype=np.float64)  # Specify float64
    rx_radius = params['rx_r_inMicroMeters']
    tx_emission_pt = np.array(params['tx_emission_pt'], dtype=np.float64)  # Specify float64
    D = params['D_inMicroMeterSqrPerSecond']
    delta_t = params['delta_t']
    tend = params['tend']
    num_molecules = params['num_molecules']

    # Initialize molecule positions at the emission point
    molecule_positions = np.tile(tx_emission_pt, (num_molecules, 1)).astype(np.float64)
    absorbed_molecules = np.zeros(num_molecules, dtype=bool)

    time_steps = int(tend / delta_t)
    cumulative_absorbed = np.zeros(time_steps)
    distances_to_rx = np.linalg.norm(molecule_positions - rx_center, axis=1)

    for t in range(time_steps):
        # Random walk (Brownian motion)
        step_size = np.sqrt(2 * D * delta_t)
        random_steps = np.random.normal(0, step_size, molecule_positions.shape)
        molecule_positions += random_steps

        # Check for absorption
        distances_to_rx = np.linalg.norm(molecule_positions - rx_center, axis=1)
        newly_absorbed = (distances_to_rx <= rx_radius) & (~absorbed_molecules)
        absorbed_molecules |= newly_absorbed  # Update absorbed molecules

        # Record cumulative absorbed molecules
        cumulative_absorbed[t] = np.sum(absorbed_molecules)

    return np.arange(0, tend, delta_t), cumulative_absorbed

def analytical_solution(params):
    rx_radius = params['rx_r_inMicroMeters']
    d = params['rx_tx_distance']
    D = params['D_inMicroMeterSqrPerSecond']
    N_tx = params['num_molecules']
    t_values = np.arange(0, params['tend'], params['delta_t'])

    F_t = (rx_radius / (rx_radius + d)) * erfc(d / np.sqrt(4 * D * t_values))
    N_Rx_t = N_tx * F_t
    return t_values, N_Rx_t

def plot_results(t_sim, cumulative_absorbed, t_analytical, N_Rx_analytical):
    plt.figure(figsize=(10, 6))
    plt.plot(t_sim, cumulative_absorbed, label='Simulated Cumulative Absorbed', linestyle='--')
    plt.plot(t_analytical, N_Rx_analytical, label='Analytical Solution', linestyle='-')
    plt.xlabel('Time (s)')
    plt.ylabel('Cumulative Absorbed Molecules')
    plt.title('Effect of Reflection on Diffusion')
    plt.legend()
    plt.show()

# Parameters for the simulation
params_task1_1 = {
    'rx_center': [0, 0, 0],
    'rx_r_inMicroMeters': 5,
    'rx_tx_distance': 5,
    'tx_emission_pt': [10, 0, 0],
    'D_inMicroMeterSqrPerSecond': 75,
    'tend': 0.4,
    'delta_t': 0.0001,
    'num_molecules': 50000
}

params_task1_2 = {
    'rx_center': [0, 0, 0],
    'rx_r_inMicroMeters': 5,
    'rx_tx_distance': 5,
    'tx_emission_pt': [10, 0, 0],
    'D_inMicroMeterSqrPerSecond': 200,
    'tend': 0.4,
    'delta_t': 0.0001,
    'num_molecules': 50000
}

# Run simulations and analytical solutions
t_sim_1, cumulative_absorbed_1 = simulate_diffusion(params_task1_1)
t_analytical_1, N_Rx_analytical_1 = analytical_solution(params_task1_1)

t_sim_2, cumulative_absorbed_2 = simulate_diffusion(params_task1_2)
t_analytical_2, N_Rx_analytical_2 = analytical_solution(params_task1_2)

# Plot results for both parameter sets
plot_results(t_sim_1, cumulative_absorbed_1, t_analytical_1, N_Rx_analytical_1)
plot_results(t_sim_2, cumulative_absorbed_2, t_analytical_2, N_Rx_analytical_2)
