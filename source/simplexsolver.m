function [x,x_ind] = simplexsolver(c,A,b,par,varargin)
% simplex method solver for constrained optimization in linear programming
% standard form of lp
% min c'*x s.t. A*x=b, x>=0

%% Input parser
P = inputParser;

% List of the optional parameters
% initial dummy basic set
P.addOptional('x_ind', init_feasible_point(A,par), @isnumeric);
% calculate the initial feasible point
P.addOptional('xb', nan, @isnumeric);

% read out the Inputs
P.parse(varargin{:});

% Extract the variabls from the Input-Parser
x_ind = P.Results.x_ind;
xb = P.Results.xb;

%% initialization
[B, N, cb, cn] = split_sets(A,c,x_ind,par);

if isnan(xb)
    % split the problem into basic(non-activ) and non-basic(activ) sets
    xb = B\b;
end
% check => xb should be non-negative
assert(sum(xb<0)==0,'malformed problem: initialization is NOT a basic feasible point.');

[m,n] = size(A);
i = 0; % number of iterations

%% main loop
while par.itr >= i
    
    [t,xq,enter_ind,leave_ind_candi] = sm_generic(cb,cn,B,N,b,'xb',xb,'itr',i);
    
    if isempty(enter_ind) % optimality
        % assemble complete solution
        xn = zeros(n-m,1);
        x = assemble_sol(xb,x_ind,'xn',xn); 
        disp('the optimal solutioin is:'); disp(x);
        return
    elseif isnan(t)
        disp('simplex method stops with the current solution:'); disp(x);
        return        
    else % keep searching
        % selection of leaving index
        if length(leave_ind_candi) ~= 1
            [t,xq,enter_ind,leave_ind] = select_leaving_ind(cb,cn,B,N,b);
            i = i + 1;
            if isnan(leave_ind)
                x = nan;
                disp('degeneracy occurs! no solution found.')
                return
            end
        else
            leave_ind = leave_ind_candi;
        end
        
        % update feasible point
        xb = xb - t*xq;
        xn = zeros(n-m,1);
        xn(enter_ind) = xq;
        % assemble complete solution
        x = assemble_sol(xb,x_ind,'xn',xn); 
        % update basic set
        p = findindx(x_ind,leave_ind,'target_num',1); % p the index of the basic var for which this minimum is achieved
                                              % => will be removed from the basic set
        x_ind(p) = 0; 
        q = findindx(x_ind,enter_ind,'target_num',0); % p the index of the non-basic var for which is select to enter
                                                %  => will be added to the basic set
        x_ind(q) = 1;
        % update the solution of basic set
        xb = x(x_ind==1);
        disp('basic set index:'); disp(x_ind');
        % update basic, nonbasic sets
        [B, N, cb, cn] = split_sets(A,c,x_ind,par);
        i = i + 1;
                
    end
end

sprintf('optimal solution not found within %d iterations => possibly cycling!', i)
disp('the current feasible point is:')
disp(x)
end