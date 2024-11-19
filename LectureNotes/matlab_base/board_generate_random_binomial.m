%% DISCRETE CASE - RNG

n = 20;
p = 0.6;
rnd_count = 100000;

rng_list = generate_random_numbers_binomialRV(n, p, rnd_count);


%% Plot CDF
figure;
h=histogram(rng_list, 'Normalization', 'cdf');
hold on; grid on;
plot(h.BinEdges, binocdf(h.BinEdges,n,p), '--', 'LineWidth', 2)

font_size = 12;
set(gca, 'fontsize', font_size)

xlabel('X', 'fontsize', font_size);
ylabel('CDF - F_X', 'fontsize', font_size);
legend('Random Numbers Histogram - CDF', 'Matlab CDF');


%% Plot PDF
figure;
h=histogram(rng_list, 'Normalization', 'pdf');
hold on; grid on;
stem(0:1:n, binopdf(0:1:n,n,p), '--', 'LineWidth', 2)

font_size = 12;
set(gca, 'fontsize', font_size)

xlabel('X', 'fontsize', font_size);
ylabel('PDF - f_X', 'fontsize', font_size);
legend('Random Numbers Histogram - PMF', 'Matlab PMF');


%%

rnd_count = 10000000;

tic;
rng_list = generate_random_numbers_binomialRV(n, p, rnd_count);
toc;

tic;
rng_list_matlab_ = binornd(n,p, [rnd_count, 1]);
toc;
