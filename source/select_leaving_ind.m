function [t,xq,enter_ind,leave_ind] = select_leaving_ind(cb,cn,B,N,b)
% selection of the leaving index for degenerated cases


%% perturbation strategy
% add perturbation to b and do one simplex step
epsilon = 1e-4; % <== tune
% ### must be small and positive. too small results in warning. ###

pert = vander(ones(length(b)+1,1)*epsilon);
pert = flip(pert(1,1:end-1));
b_pert = b + pert';

[t,xq,enter_ind,leave_ind_candi] = sm_generic(cb,cn,B,N,b_pert);
   
if length(leave_ind_candi) == 1 % perturbation success
    leave_ind = leave_ind_candi;
else  % perturbation fail
    warning('inception of perturbation strategy => increase perturbation (epsilon).')
    leave_ind = nan;
    return
end

end