%% DISCRETE CASE - RNG

lambda = 5;
rnd_count = 10000;

rng_list = generate_random_numbers_exponentialRV(lambda, rnd_count);


%% Plot CDF
figure;
h=histogram(rng_list, 'Normalization', 'cdf');
hold on; grid on;
plot(h.BinEdges, expcdf(h.BinEdges,1/lambda), '--', 'LineWidth', 2)

font_size = 12;
set(gca, 'fontsize', font_size)

xlabel('X', 'fontsize', font_size);
ylabel('CDF - F_X', 'fontsize', font_size);
legend('Random Numbers Histogram - CDF', 'Matlab CDF');


%% Plot PDF
figure;
h=histogram(rng_list, 'Normalization', 'pdf');
hold on; grid on;
plot(h.BinEdges, exppdf(h.BinEdges,1/lambda), '--', 'LineWidth', 2)

font_size = 12;
set(gca, 'fontsize', font_size)

xlabel('X', 'fontsize', font_size);
ylabel('PDF - f_X', 'fontsize', font_size);
legend('Random Numbers Histogram - PDF', 'Matlab PDF');


