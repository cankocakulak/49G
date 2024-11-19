function [num_success] = monte_carlo_dart2quadrant(N)
x = rand([N,1]);
y = rand([N,1]);

radii = x.^2 + y.^2;

success_mask = radii < 1;

% Number of successful cases among N experiments/replications
num_success = sum(success_mask);

end

