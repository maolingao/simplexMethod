function x = zeropadding(x_partial,x_ind)
% expan x_partial to the length of the x_ind, with its positioning
% according to x_ind.
% the vacancy will be filled with zeros.
%% 
n = length(x_ind);

x = zeros(n,1);
 
x(x_ind==1) = x_partial;

end