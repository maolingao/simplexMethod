function  [e,AE] = init_prob_construct(A,b,par)
% construct the phase I opti prob

[m,n] = size(A);
diag_pos = b >= 0;
diag_neg = b <  0;

E_diag = nan(m,1);
E_diag(diag_pos) = 1;
E_diag(diag_neg) = -1;

E = diag(E_diag);

AE = [A,E];
e = zeros(m+n,1);
e(n+1:end) = 1;

end