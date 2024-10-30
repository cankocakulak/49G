function [rng_list] = generate_random_numbers_binomialRV(n, p, rnd_count)
uniform_randoms = rand([rnd_count, n]);

success_mask = uniform_randoms < p;

rng_list = sum(success_mask, 2);
end
