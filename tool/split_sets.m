function [B, N, cb, cn] = split_sets(A,c,x_ind,par)
% split the problem into basic(non-active) and non-basic(active) sets

B = extract_element(A,x_ind,par); % the basic matrix B, must be square matrix with full rank
N = extract_element(A,x_ind==0, par);

cb = extract_element(c,x_ind,par);
cn = extract_element(c,x_ind==0, par);

end