function [x] = simplexsolver(c,A,b,par)
% simplex method solver for constrained optimization in linear programming
% standard form of lp
% min c'*x s.t. A*x=b, x>=0

%% 
[m,n] = size(A);
% initial dummy feasible point
x_ind = init_feasible_point(A,par);
% split the problem into basic(non-activ) and non-basic(activ) sets
B = extract_element(A,x_ind,par); % the basic matrix B
cb = extract_element(c,x_ind,par);
cn = extract_element(c,x_ind==0, par);
N = extract_element(A,x_ind==0, par);

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
        disp('optimal solution found!')
        return
    else
        % select the entering index column in matrix A
        Aq = N(:,enter_ind);
        % compute t
        t = B\Aq;

        if t <= 0 % unbounded problem
            % assemble solution according to xb, its position x_ind and xn = 0
            x = assemble_sol(xb,x_ind); 
            disp('the problem is unbounded!')
            return
        else % update feasible point

            [xq,q_ind] = min(xb./(t+eps));
            % update feasible point
            xb = xb - t*xq;
            xn = zeros(n-m,1);
            xn(enter_ind) = xq;
            par.xn = xn; 
            x = assemble_sol(xb,x_ind,'xn',xn); 
            x(x<1e-6) = 0;
            [row,~,xb] = find(x);
            x_ind = zeros(n,1);
            x_ind(row) = 1;
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