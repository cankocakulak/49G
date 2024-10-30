function [rng_list] = generate_random_numbers_normalRV(mu, sigma, rnd_count)
uniform_randoms = rand([rnd_count, 1]);

rng_list = norminv(uniform_randoms, mu, sigma);
end

