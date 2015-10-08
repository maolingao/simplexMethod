function [x] = simplexsolver(c,A,b,par)
% simplex method solver for constrained optimization in linear programming
% standard form of lp
% min c'*x s.t. A*x=b, x>=0

%% initialization
[m,n] = size(A);
% initial dummy basic set
x_ind = init_feasible_point(A,par);
% split the problem into basic(non-activ) and non-basic(activ) sets
[B, N, cb, cn] = split_sets(A,c,x_ind,par);
% calculate the initial feasible point
xb = B\b; % check => xb should be non-negative
i = 0; % number of iterations
%% main loop
while par.itr >= i
    
    [t,xq,enter_ind,leave_ind_candi] = sm_generic(cb,cn,B,N,b,'xb',xb,'itr',i);
    
    if isempty(enter_ind) % optimality
        disp('the optimal solutioin is:'); disp(x);
        return
        
    else % keep searching
        % update feasible point
        xb = xb - t*xq;
        xn = zeros(n-m,1);
        xn(enter_ind) = xq;
        % assemble complete solution
        x = assemble_sol(xb,x_ind,'xn',xn); 
        % selection of leaving index
        if length(leave_ind_candi) ~= 1
            leave_ind = select_leaving_ind(B,leave_ind_candi);
        else
            leave_ind = leave_ind_candi;
        end
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

sprintf('optimal solution not found within %d iterations => possibly cycling!',par.itr)
disp('the current feasible point is:')
disp(x)
end