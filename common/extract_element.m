function x_tar = extract_element(x,x_ind,par)
% extract elements from x (vector or matrix) according to the index x_ind

[m,n]   = size(x);
 if m == 1
     x = x';
     [m,n]   = size(x);
 end
 
 switch n
     case 1 % x is vector
         x_tar = x(x_ind==1);
     otherwise % x is matrix
         x_tar = x(:,x_ind==1);
 end
         

end