%%

N = 10000000;

[num_success] = monte_carlo_dart2quadrant(N);

estimated_pi_value = 4 * num_success/N;

%% 

N_values = [10^4 10^5 10^6 10^7 10^8];
num_values = size (N_values,2);

estimated_pi_values = zeros(1,num_values);
for ii=1:num_values
    curr_N = N_values(ii);
    
    num_success = monte_carlo_dart2quadrant(curr_N);
    
    estimated_pi_values(ii) = 4 * num_success/curr_N; 
end

%% 

figure;
loglog(N_values, abs(estimated_pi_values-pi));