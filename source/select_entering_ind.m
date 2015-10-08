function enter_ind = select_entering_ind(sn)
% pricing strategy to choose the entering index

if isempty(sn)
    enter_ind = [];
    return
end

% all index with negative entries
enter_ind_candi = find(sn < 0);

%% selection rules
if isempty(enter_ind_candi) % no negative entries => optimality!
    enter_ind = [];
    return
else % selection rules go here
    % Dantzig's selection
    % choose the most negative one
    [~,enter_ind] = min(sn);
end

end