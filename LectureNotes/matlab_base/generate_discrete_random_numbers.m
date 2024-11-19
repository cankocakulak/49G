function [rng_list, flag] = generate_discrete_random_numbers(pmf, rnd_count)
% Flag for checking valid PMF
flag = true;
if (sum(pmf)~= 1.0)
    rng_list = [];
    flag = false;
end

if (flag==true)
    num_values = size(pmf, 2);
    cdf_values = cumsum(pmf);
    
    uniform_randoms = rand([rnd_count,1]);
    
    % Replicate Uniform Numbers through column
    uniform_randoms = repmat(uniform_randoms, [1,num_values]); 
    
    % Replicate CDF values through row
    cdf_values = repmat(cdf_values, [rnd_count,1]); 
    
    % Generate CDF mask indicating cdf values that are higher than R.N 
    cdf_mask = uniform_randoms < cdf_values ;
    
    % Map the mask to the symbol index
    rng_list = num_values + 1 - sum(cdf_mask,2);
    % Example Scenarios for a row in cdf_mask
    % rnd=0.001 [1 1 1 ] --> 1
    % rnd=0.999 [0 0 1 ] --> 3
end

end

