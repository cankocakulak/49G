%% DISCRETE CASE - RNG

mu = 10;
sigma = 2;
rnd_count = 100000;

rng_list = generate_random_numbers_normalRV(mu, sigma, rnd_count);


%% Plot CDF
figure;
h=histogram(rng_list, 'Normalization', 'cdf');
hold on; grid on;
plot(h.BinEdges, normcdf(h.BinEdges,mu,sigma), '--', 'LineWidth', 2)

font_size = 12;
set(gca, 'fontsize', font_size)

xlabel('X', 'fontsize', font_size);
ylabel('CDF - F_X', 'fontsize', font_size);
legend('Random Numbers Histogram - CDF', 'Matlab CDF');


%% Plot PDF
figure;
h=histogram(rng_list, 'Normalization', 'pdf');
hold on; grid on;
plot(h.BinEdges, normpdf(h.BinEdges,mu,sigma), '--', 'LineWidth', 2)

font_size = 12;
set(gca, 'fontsize', font_size)

xlabel('X', 'fontsize', font_size);
ylabel('PDF - f_X', 'fontsize', font_size);
legend('Random Numbers Histogram - PDF', 'Matlab PDF');


