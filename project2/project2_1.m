function molecular_diffusion_simulation()
    % Parameters for Task 1-1
    params.rx_center = [0, 0, 0];
    params.rx_r_inMicroMeters = 5;
    params.rx_tx_distance = 5;
    params.tx_emission_pt = [10, 0, 0];
    params.D_inMicroMeterSqrPerSecond = 75;
    params.tend = 0.4;
    params.delta_t = 0.0001;
    params.num_molecules = 50000;

    % Run simulation and analytical solution
    [t_sim, cumulative_absorbed] = simulate_diffusion(params);
    [t_analytical, N_Rx_analytical] = analytical_solution(params);

    % Plot the results
    figure;
    plot(t_sim, cumulative_absorbed, '--', 'DisplayName', 'Simulated Cumulative Absorbed');
    hold on;
    plot(t_analytical, N_Rx_analytical, '-', 'DisplayName', 'Analytical Solution');
    xlabel('Time (s)');
    ylabel('Cumulative Absorbed Molecules');
    title('Effect of Reflection on Diffusion');
    legend;
    hold off;
end

function [t_values, cumulative_absorbed] = simulate_diffusion(params)
    % Extract parameters
    rx_center = params.rx_center;
    rx_radius = params.rx_r_inMicroMeters;
    tx_emission_pt = params.tx_emission_pt;
    D = params.D_inMicroMeterSqrPerSecond;
    delta_t = params.delta_t;
    tend = params.tend;
    num_molecules = params.num_molecules;

    % Initialize molecules at emission point
    molecule_positions = repmat(tx_emission_pt, num_molecules, 1);
    absorbed_molecules = false(num_molecules, 1);

    % Initialize time variables
    time_steps = round(tend / delta_t);
    cumulative_absorbed = zeros(time_steps, 1);

    % Simulate diffusion
    for t = 1:time_steps
        % Random walk step (Brownian motion)
        step_size = sqrt(2 * D * delta_t);
        random_steps = step_size * randn(num_molecules, 3);
        molecule_positions = molecule_positions + random_steps;

        % Check if molecules are absorbed
        distances_to_rx = sqrt(sum((molecule_positions - rx_center).^2, 2));
        newly_absorbed = (distances_to_rx <= rx_radius) & ~absorbed_molecules;
        absorbed_molecules = absorbed_molecules | newly_absorbed;

        % Record cumulative absorbed molecules
        cumulative_absorbed(t) = sum(absorbed_molecules);
    end

    % Time vector
    t_values = (0:time_steps - 1) * delta_t;
end

function [t_values, N_Rx_t] = analytical_solution(params)
    % Extract parameters
    rx_radius = params.rx_r_inMicroMeters;
    d = params.rx_tx_distance;
    D = params.D_inMicroMeterSqrPerSecond;
    N_tx = params.num_molecules;
    delta_t = params.delta_t;
    tend = params.tend;

    % Time vector
    t_values = (0:delta_t:tend - delta_t)';

    % Analytical solution for cumulative absorbed molecules
    F_t = (rx_radius / (rx_radius + d)) * erfc(d ./ sqrt(4 * D * t_values));
    N_Rx_t = N_tx * F_t;
end
