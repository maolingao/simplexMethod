function x = zeropadding(x_partial,x_ind,par)
% expan x_partial to the length of the x_ind, with its positioning
% according to x_ind.
% the vacancy will be filled with zeros.

n = length(x_ind);

x = zeros(n,1);
 
x(x_ind) = x_partial;

end