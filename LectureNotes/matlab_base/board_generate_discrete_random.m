%% DISCRETE CASE - RNG

pmf = [1/6, 2/6, 3/6]; % cdf = [1/6, 3/6, 6/6]
rnd_count = 100000;

[rng_list, flag] = generate_discrete_random_numbers(pmf, rnd_count);


%% Plot
figure;
h=histogram(rng_list, 'Normalization', 'pdf');
hold on; grid on;

font_size = 12;
set(gca, 'fontsize', font_size)
text(1, h.Values(1)+0.015, num2str(h.Values(1)));
text(2, h.Values(2)+0.015, num2str(h.Values(2)));
text(3, h.Values(3)+0.015, num2str(h.Values(3)));

xlabel('X', 'fontsize', font_size);
ylabel('PMF - f_X', 'fontsize', font_size);
xticks([1 2 3])

saveas(h, 'simulation_plott.png');
disp('Plot saved as simulation_plot.png');
