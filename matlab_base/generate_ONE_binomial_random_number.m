function [random_number] = generate_ONE_binomial_random_number(n, p)

uniform_randoms = rand([1, n]);

success_mask = uniform_randoms < p;

random_number = sum(success_mask, 2);
end
