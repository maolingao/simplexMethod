function [x] = simplexsolver(c,A,b,par)
% simplex method solver for constrained optimization in linear programming
% standard form of lp
% min c'*x s.t. A*x=b, x>=0

%% 
[m,n] = size(A);
% initial dummy feasible point
x_ind = init_feasible_point(A,par);
% split the problem into basic(non-activ) and non-basic(activ) sets
[B, N, cb, cn] = split_sets(A,c,x_ind,par);

% calculate the initial feasible point
xb = B\b; % check => xb should be non-negative
i = 0; % number of iterations
while par.itr >= i
    % compute pii and sn
    pii = B'\cb;
    sn = cn - N'*pii;
    enter_ind = find(sn < 0, 1,'first');
    if isempty(enter_ind)
        % assemble solution according to xb, its position x_ind and xn = 0
        x = assemble_sol(xb,x_ind); 
        sprintf('optimal solution found at the %d-th iteration.',i)
        disp(x)
        return
    else
        % select the entering index column in matrix A
        Aq = N(:,enter_ind);
        % compute t
        t = B\Aq;

        if sum(t < 0) == length(t) % unbounded problem
            % assemble solution according to xb, its position x_ind and xn = 0
            x = assemble_sol(xb,x_ind); 
            sprintf('the problem is unbounded. The fact is found at the %d-th iteration.',i)
            return
        else % update feasible point
            t_pos = clip(t,0,inf); % only pick out the positive entries in t
            ratio = round((xb./(t_pos+eps)).*1e6) ./ 1e6; % numerical stable
            [xq,q_ind_B] = min(ratio); % determine which element in basic set will be driven to zero at first
            q_ind_B = find(ratio==xq); q_ind_B = q_ind_B(end);
            p = findindx(x_ind,q_ind_B,'target_num',1); % p the index of the basic var for which this minimum is achieved
                                                  % => will be removed from the basic set
            % update feasible point
            xb = xb - t*xq;
            xn = zeros(n-m,1);
            xn(enter_ind) = xq;
            % update the current feasible point
            x = assemble_sol(xb,x_ind,'xn',xn); 
            x(x<1e-6) = 0; % numerical stable
            % update the index of basic set
            x_ind(p) = 0; 
            q = findindx(x_ind,enter_ind,'target_num',0); % p the index of the non-basic var for which is select to enter
                                                    %  => will be added to the basic set
            x_ind(q) = 1;
            % update the solution of basic set
            xb = x(x_ind==1);
            disp('basic set index:')
            disp(x_ind')
%             pause
        end
        % update basic, nonbasic sets
        [B, N, cb, cn] = split_sets(A,c,x_ind,par);
    end
    i = i + 1;
end

sprintf('optimal solution not found within %d iterations => possibly cycling!',par.itr)
disp('current feasible point is:')
disp(x)
end