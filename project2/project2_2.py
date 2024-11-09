import numpy as np
import matplotlib.pyplot as plt
import time

#After installing the required packages, run the following code to simulate the diffusion of molecules in a 2D environment with a reflecting obstacle.
# python project2_2.py

# Define base parameter set
base_params = {
    'rx_center': np.array([0, 0]),  # 2D coordinates
    'rx_r_inMicroMeters': 5,
    'rx_tx_distance': 7,
    'tx_emission_pt': np.array([12, 0]),  # Fixed at x=12
    'D_inMicroMeterSqrPerSecond': 75,
    'line_opening_h_inMicroM': 2,
    'tend': 1.5,
    'delta_t': 0.0001,
    'num_molecules': 50000
}

# Create parameter sets with different reflecting wall positions
param_sets = []
for pos in [3, 5, 7, 9]:  # A values
    params = base_params.copy()
    
    # Calculate actual distances accounting for receiver radius (rr)
    actual_tx_rx_distance = params['rx_tx_distance'] - params['rx_r_inMicroMeters']  # d - rr
    actual_wall_rx_distance = pos - params['rx_r_inMicroMeters']  # a - rr
    
    # Set positions
    params['reflecting_line_eqn_A'] = pos  # a
    params['actual_tx_rx_distance'] = actual_tx_rx_distance
    params['actual_wall_rx_distance'] = actual_wall_rx_distance
    
    print(f"\nFor wall position {pos}µm:")
    print(f"Actual Tx-Rx distance (d-rr): {actual_tx_rx_distance}µm")
    print(f"Actual Wall-Rx distance (a-rr): {actual_wall_rx_distance}µm")
    print(f"Tx position: {params['tx_emission_pt'][0]}µm")
    print(f"Wall position: {pos}µm")
    
    param_sets.append(params)


def check_reflection(positions, reflecting_x, tx_x, opening_height, buffer_distance=0.1):
    """Check and handle reflections at the obstacle"""
    """buffer_distance is added in order to avoid checking the molecules that already passed the opening"""
    if reflecting_x < tx_x:  # Wall is on left side of transmitter
        # Find molecules that hit the reflecting line from right
        hit_mask = (positions[:, 0] <= reflecting_x) & (positions[:, 0] >= reflecting_x - buffer_distance)
    else:  # Wall is on right side of transmitter
        # Find molecules that hit the reflecting line from left
        hit_mask = (positions[:, 0] >= reflecting_x) & (positions[:, 0] <= reflecting_x + buffer_distance)
    
    if np.any(hit_mask):  # Only proceed if there are molecules hitting the wall
        # Among hit molecules, find which ones are at the opening
        at_opening = np.abs(positions[hit_mask, 1]) <= opening_height / 2
        
        # Create mask for molecules that should be reflected
        reflect_mask = hit_mask.copy()
        reflect_mask[hit_mask] = ~at_opening
        
        # Reflect molecules that hit the wall (not at opening)
        positions[reflect_mask, 0] = 2 * reflecting_x - positions[reflect_mask, 0]
    
    return positions
    
def simulate_diffusion(params):
    """Debug statement to track the simulation from terminal and see potential issues"""

    print(f"\nInitializing simulation with parameters:")
    print(f"- Wall position (a): {params['reflecting_line_eqn_A']}µm")
    print(f"- Actual Wall-Rx distance (a-rr): {params['actual_wall_rx_distance']}µm")
    print(f"- Actual Tx-Rx distance (d-rr): {params['actual_tx_rx_distance']}µm")
    print(f"- Opening height: {params['line_opening_h_inMicroM']}µm")
    
    rx_center = np.array(params['rx_center'], dtype=np.float64)
    rx_radius_sq = params['rx_r_inMicroMeters'] ** 2
    tx_emission_pt = np.array(params['tx_emission_pt'], dtype=np.float64)
    D = params['D_inMicroMeterSqrPerSecond']
    delta_t = params['delta_t']
    num_molecules = params['num_molecules']
    num_steps = int(params['tend'] / delta_t)
    reflecting_x = params['reflecting_line_eqn_A']
    opening_height = params['line_opening_h_inMicroM']
    tx_x = params['tx_emission_pt'][0]


    # Standard deviation of the step size for Brownian motion
    sigma = np.sqrt(2 * D * delta_t)

    # Initialize molecules at the transmitter position
    mol_positions = np.tile(tx_emission_pt, (num_molecules, 1)).astype(np.float64)
    nRx_timeline = np.zeros(num_steps)  # Track absorption per step
    
    # Add progress tracking
    progress_interval = num_steps // 10
    molecules_remaining = num_molecules
    absorbed_total = 0
    
    print("\nStarting simulation steps...")

    for step in range(num_steps):
        if step % progress_interval == 0:
            percent_complete = (step / num_steps) * 100
            print(f"Progress: {percent_complete:.1f}% | Molecules remaining: {molecules_remaining}")
        
        # Move molecules
        displacements = np.random.normal(0, sigma, size=mol_positions.shape)
        mol_positions += displacements

        # Handle reflections
        mol_positions = check_reflection(mol_positions, reflecting_x, tx_x, opening_height)

        # Check absorption
        distances_sq = np.sum((mol_positions - rx_center) ** 2, axis=1)
        hit_mask = distances_sq <= rx_radius_sq
        absorbed_this_step = np.sum(hit_mask)
        nRx_timeline[step] = absorbed_this_step
        
        if absorbed_this_step > 0:
            absorbed_total += absorbed_this_step
            molecules_remaining -= absorbed_this_step
        
        # Remove absorbed molecules
        mol_positions = mol_positions[~hit_mask]

        if len(mol_positions) == 0:
            print("\nAll molecules absorbed! Ending simulation early.")
            break
    
    print(f"\nSimulation completed:")
    print(f"- Total molecules absorbed: {absorbed_total}")
    print(f"- Molecules remaining: {molecules_remaining}")
    print(f"- Absorption rate: {(absorbed_total/num_molecules)*100:.1f}%")

    time_steps = np.arange(delta_t, params['tend'] + delta_t, delta_t)
    return nRx_timeline, time_steps, mol_positions

# Run simulations
results = []
for i, params in enumerate(param_sets):
    print(f"\n{'='*50}")
    print(f"Starting Simulation Set {i+1}/4")
    print(f"Wall position: x = {params['reflecting_line_eqn_A']}µm")
    print(f"{'='*50}")
    
    start_time = time.time()
    result = simulate_diffusion(params)
    duration = time.time() - start_time
    
    results.append(result)
    print(f"\nSimulation {i+1} completed in {duration:.2f} seconds")
    print(f"{'='*50}")

def plot_all_results(results, param_sets):
    plt.figure(figsize=(12, 8))
    
    colors = ['b', 'g', 'r', 'm']
    max_molecules = 0
    
    for i, (nRx_sim, time_sim, _) in enumerate(results):
        wall_pos = param_sets[i]['reflecting_line_eqn_A']
        nRx_sim_cumulative = np.cumsum(nRx_sim)
        max_molecules = max(max_molecules, nRx_sim_cumulative[-1])
        
        plt.plot(time_sim, nRx_sim_cumulative, '-', 
                color=colors[i], linewidth=2, 
                label=f'Wall at x={wall_pos}µm (Final count: {nRx_sim_cumulative[-1]:.0f})')

    plt.xlabel('Time (s)')
    plt.ylabel('Cumulative Number of Received Molecules')
    plt.legend()
    plt.grid(True)
    plt.title('2D Diffusion with Reflecting Obstacle:\n' +
              f'Comparison of Different Wall Positions (Max absorbed: {max_molecules:.0f})')
    plt.savefig('cumulative_comparison_plot.png')
    plt.show()

def plot_all_environments(param_sets, results):
    fig, axs = plt.subplots(2, 2, figsize=(15, 15))
    axs = axs.ravel()
    
    for i, (params, (_, _, final_positions)) in enumerate(zip(param_sets, results)):
        ax = axs[i]
        
        # Plot receiver
        circle = plt.Circle(params['rx_center'], params['rx_r_inMicroMeters'], 
                          color='r', fill=False)
        ax.add_patch(circle)
        
        # Plot reflecting wall with opening
        wall_y = np.linspace(-20, 20, 100)
        wall_x = np.ones_like(wall_y) * params['reflecting_line_eqn_A']
        opening_mask = np.abs(wall_y) > params['line_opening_h_inMicroM']/2
        ax.plot(wall_x[opening_mask], wall_y[opening_mask], 'k-')
        
        # Plot transmitter
        ax.plot(params['tx_emission_pt'][0], params['tx_emission_pt'][1], 'go')
        
        # Plot final positions
        if final_positions is not None and len(final_positions) > 0:
            ax.scatter(final_positions[:, 0], final_positions[:, 1], 
                      alpha=0.5, s=1)
        
        ax.set_aspect('equal')
        ax.grid(True)
        ax.set_title(f'Wall at x={params["reflecting_line_eqn_A"]}µm')
        ax.set_xlabel('x (µm)')
        ax.set_ylabel('y (µm)')
        ax.set_xlim(-5, 15)
        ax.set_ylim(-10, 10)
    
    plt.tight_layout()
    plt.savefig('all_environments.png')
    plt.show()

# Plot results
plot_all_results(results, param_sets)
plot_all_environments(param_sets, results)