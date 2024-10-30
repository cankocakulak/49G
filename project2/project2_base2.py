import numpy as np
import matplotlib.pyplot as plt
import time

# Define parameter set for 2D with reflecting obstacle
sim_params = {
    'rx_center': np.array([0, 0]),  # 2D coordinates
    'rx_r_inMicroMeters': 5,
    'rx_tx_distance': 7,
    'tx_emission_pt': np.array([12, 0]),  # 2D coordinates
    'D_inMicroMeterSqrPerSecond': 75,
    'reflecting_line_eqn_A': 7,  # x = 7 line
    'line_opening_h_inMicroM': 2,
    'tend': 1.5,
    'delta_t': 0.0001,
    'num_molecules': 50000
}

def check_reflection(positions, reflecting_x, opening_height):
    """Check and handle reflections at the obstacle"""
    # Find molecules that hit the reflecting line
    hit_mask = positions[:, 0] <= reflecting_x
    
    if np.any(hit_mask):  # Only proceed if there are molecules hitting the wall
        # Among hit molecules, find which ones are at the opening
        at_opening = np.abs(positions[hit_mask, 1]) <= opening_height/2
        
        # Create mask for molecules that should be reflected (hit wall but not at opening)
        reflect_mask = hit_mask.copy()
        reflect_mask[hit_mask] = ~at_opening
        
        # Reflect molecules that hit the wall (not at opening)
        positions[reflect_mask, 0] = 2*reflecting_x - positions[reflect_mask, 0]
    
    return positions
    
def simulate_diffusion(params):
    rx_center = np.array(params['rx_center'], dtype=np.float64)
    rx_radius_sq = params['rx_r_inMicroMeters'] ** 2
    tx_emission_pt = np.array(params['tx_emission_pt'], dtype=np.float64)
    D = params['D_inMicroMeterSqrPerSecond']
    delta_t = params['delta_t']
    num_molecules = params['num_molecules']
    num_steps = int(params['tend'] / delta_t)
    reflecting_x = params['reflecting_line_eqn_A']
    opening_height = params['line_opening_h_inMicroM']

    sigma = np.sqrt(2 * D * delta_t)
    mol_positions = np.tile(tx_emission_pt, (num_molecules, 1)).astype(np.float64)
    nRx_timeline = np.zeros(num_steps)

    for step in range(num_steps):
        # Generate 2D random displacements
        displacements = np.random.normal(0, sigma, size=mol_positions.shape)
        mol_positions += displacements

        # Handle reflections at the obstacle
        mol_positions = check_reflection(mol_positions, reflecting_x, opening_height)

        # Calculate squared distances to receiver
        distances_sq = np.sum((mol_positions - rx_center) ** 2, axis=1)
        hit_mask = distances_sq <= rx_radius_sq
        nRx_timeline[step] = np.sum(hit_mask)
        
        # Remove absorbed molecules
        mol_positions = mol_positions[~hit_mask]

        # If no molecules left, break
        if len(mol_positions) == 0:
            break

    time_steps = np.arange(delta_t, params['tend'] + delta_t, delta_t)
    return nRx_timeline, time_steps, mol_positions

def plot_environment(params, final_positions=None):
    """Visualize the simulation environment"""
    plt.figure(figsize=(10, 8))
    
    # Plot receiver
    circle = plt.Circle(params['rx_center'], params['rx_r_inMicroMeters'], 
                       color='r', fill=False, label='Receiver')
    plt.gca().add_patch(circle)
    
    # Plot reflecting wall with opening
    wall_y = np.linspace(-20, 20, 100)
    wall_x = np.ones_like(wall_y) * params['reflecting_line_eqn_A']
    opening_mask = np.abs(wall_y) > params['line_opening_h_inMicroM']/2
    plt.plot(wall_x[opening_mask], wall_y[opening_mask], 'k-', label='Reflecting Wall')
    
    # Plot transmitter position
    plt.plot(params['tx_emission_pt'][0], params['tx_emission_pt'][1], 'go', 
             label='Transmitter')
    
    # Plot final positions if provided
    if final_positions is not None and len(final_positions) > 0:
        plt.scatter(final_positions[:, 0], final_positions[:, 1], 
                   alpha=0.5, label='Final Molecule Positions')
    
    plt.axis('equal')
    plt.grid(True)
    plt.legend()
    plt.title('2D Diffusion Environment with Reflecting Obstacle')
    plt.xlabel('x (µm)')
    plt.ylabel('y (µm)')
    plt.savefig('environment_2D.png')
    plt.show()

# Run simulation
print("Simulation [START]")
start_time = time.time()
nRx_sim, time_sim, final_positions = simulate_diffusion(sim_params)
print(f"Simulation [END] Duration: {time.time() - start_time:.2f} seconds")

# Calculate cumulative sum
nRx_sim_cumulative = np.cumsum(nRx_sim)

# Plot results
plt.figure(figsize=(10, 6))
plt.plot(time_sim, nRx_sim_cumulative, '-', linewidth=2, label='Simulation')
plt.xlabel('Time (s)')
plt.ylabel('Cumulative Number of Received Molecules')
plt.legend()
plt.grid(True)
plt.title('2D Diffusion with Reflecting Obstacle:\nCumulative Received Molecules vs Time')
plt.savefig('cumulative_simulation_plot_2D_obstacle.png')
plt.show()

# Visualize the environment
plot_environment(sim_params, final_positions)