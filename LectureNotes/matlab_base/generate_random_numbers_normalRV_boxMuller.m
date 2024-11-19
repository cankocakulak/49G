function [rng_list] = generate_random_numbers_normalRV_boxMuller(mu, sigma, rnd_count)
uniform_randoms = rand([round(rnd_count/2), 2]);

R_values = sqrt(-2*log(uniform_randoms(:,1)));
theta_values = 2*pi*uniform_randoms(:,2);

rng_list_1 = R_values .* cos(theta_values);
rng_list_2 = R_values .* sin(theta_values);

rng_list = mu + sigma*[rng_list_1; rng_list_2];
end

