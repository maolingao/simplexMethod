function [t,xq,enter_ind,leave_ind_candi] = sm_generic(cb,cn,B,N,b,varargin)
% the generic simplex method solver
% excute one simplex step

%% Input parser
P = inputParser;

% List of the optional parameters
P.addOptional('xb', B\b, @isnumeric);
P.addOptional('itr', 0, @isnumeric);

% read out the Inputs
P.parse(varargin{:});

% Extract the variabls from the Input-Parser
xb = P.Results.xb;
itr = P.Results.itr;

%%
% compute pii and sn
pii = B'\cb;
sn = cn - N'*pii;
% ###### selection of entering index ######
enter_ind = select_entering_ind(sn);

if isempty(enter_ind)
    sprintf('optimal solution found at the %d-th iteration.',itr)
    t = nan; xq = nan; leave_ind_candi = nan;
    return
else
    % select the entering index column in matrix A
    Aq = N(:,enter_ind);
    % compute t
    t = B\Aq;

    if sum(t < 0) == length(t) % unbounded problem
        sprintf('the problem is unbounded. The fact is found at the %d-th iteration.',itr)
    t = nan; xq = nan; leave_ind_candi = nan;
        return
    else % update feasible point
        t_pos = clip(t,0,inf); % only pick out the positive entries in t
        ratio = round((xb./(t_pos+eps)).*1e6) ./ 1e6; % numerical stable
        [xq,~] = min(ratio); 
        leave_ind_candi = find(ratio==xq); % determine which element in basic set will be driven to zero at first
                                           % if solution is multiple => degeneracy case
    end
end


end