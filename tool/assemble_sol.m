function  x = assemble_sol(xb,x_ind,varargin)
% assemble solution using xb, its position index x_ind and xn
n = length(x_ind); 
m = sum(x_ind);
%% Input parser
P = inputParser;

% List of the optional parameters
P.addOptional('xn', zeros(n-m,1), @isnumeric);

% read out the Inputs
P.parse(varargin{:});

% Extract the variabls from the Input-Parser
xn = P.Results.xn;

%%
xb = zeropadding(xb,x_ind);
xn = zeropadding(xn,x_ind==0);

x = xb + xn; 

x(x<1e-6) = 0; % numerical stable

end