function [x] = simplexsolver(c,A,b,par)
% simplex method solver for constrained optimization in linear programming
% standard form of lp
% min c'*x s.t. A*x=b, x>=0

%% 
% initial dummy feasible point
x_ind = init_feasible_point(A,par);
% split the problem into basic(non-activ) and non-basic(activ) sets
B = extract_element(A,x_ind,par); % the basic matrix B
cb = extract_element(c,x_ind,par);
cn = extract_element(c,x_ind==0, par);
N = extract_element(A,x_ind==0, par);

% calculate the initial feasible point
xb = b/B; % check => xb should be non-negative
i = 0; % number of iterations
while par.itr >= i
    % compute pii and sn
    pii = cb/B';
    sn = cn - N'*pii;
    enter_ind = find(sn < 0, 1,'first');
    if isempty(enter_ind)
        % assemble solution according to xb, its position x_ind and xn = 0
        x = assemble_sol(xb,x_ind,par); 
        disp('optimal solution found!')
        return
    else
        % select the entering index column in matrix A
        Aq = N(:,enter_ind);
        % compute t
        t = Aq/B;

        if t <= 0 % unbounded problem
            % assemble solution according to xb, its position x_ind and xn = 0
            x = assemble_sol(xb,x_ind,par); 
            disp('the problem is unbounded!')
            return
        else % update feasible point
            t_reg = t;
            t_reg(t==0) = inf;

            [xq,q_ind] = min(xb./t_reg);
            % update feasible point
            xb = xb - t*xq;
            xn = zeros(n-m,1);
            xn(enter_ind) = xq;
            par.xn = xn; 
            x = assemble_sol(xb,x_ind,par); 
            [xb, x_ind] = find(x ~= 0);
        end
        % update basic, nonbasic sets
        B = extract_element(A,x_ind,par); % the basic matrix B
        cb = extract_element(c,x_ind,par);
        cn = extract_element(c,x_ind==0, par);
        N = extract_element(A,x_ind==0, par);
    end
end

% assemble solution according to xb, its position x_ind and xn = 0
x = assemble_sol(xb,x_ind,par); 
sprintf('optimal solution not found within %d iterationdts!',par.itr);
return
end