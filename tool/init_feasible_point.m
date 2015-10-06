function x_ind = init_feasible_point(A,par)
% give the index an initial feasible point for the lp problem
[m,n] = size(A);
x_ind = zeros(n,1);
x_ind(n-m+1 : n) = 1;

end