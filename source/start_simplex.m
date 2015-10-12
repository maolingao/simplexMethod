function [x] = start_simplex(c,A,b,par,varargin)
% start simplex solver with automatic searching an feasible point
% by solve the problem :
% min norm(z,'1'), s.t. A*x + E*z = b, (x,z) > 0.
% where E_{jj} = +1 if b_j >= 0 
%       E_{jj} = -1 if b_j <  0 

%% Input parser
P = inputParser;

% List of the optional parameters
P.addOptional('do_init_search', false, @islogical);

% read out the Inputs
P.parse(varargin{:});

% Extract the variabls from the Input-Parser
do_init_search = P.Results.do_init_search;

switch do_init_search
    case 1
        %% phase I
        % find a feasible starting point
        % construct phase I optimization problem
        disp('searching for a feasible starting point......')
        [e,AE] = init_prob_construct(A,b,par);
        [m,n] = size(AE);
        z_ind = zeros(n,1);
        zb =  abs(b);
        z_ind(n-m+1:n) = 1;
        % solve it using simplex method
        [z,z_ind] = simplexsolver(e,AE,b,par,'xb',zb,'x_ind',z_ind);

        %% phase II
        if norm(z(n-m+1:end),1) > 0
            disp('A feasible starting point is NOT found.')
            error('original problem is infeasible!')
        else
            disp('A feasible starting point is found as above!')
            disp('Start solving the original problem......')
            disp('computing......')
            [x,x_ind] = simplexsolver(c,A,b,par,'xb',z(z_ind==1),'x_ind',z_ind(1:n-m));
        end
    case 0
        disp('Start solving the original problem using trivial initialization......')
        [x,x_ind] = simplexsolver(c,A,b,par);
end
end