function [rng_list] = generate_random_numbers_exponentialRV(lambda, rnd_count)
uniform_randoms = rand([rnd_count,1]);

rng_list = (-1/lambda) * log(uniform_randoms);
end

