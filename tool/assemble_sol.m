function  x = assemble_sol(xb,x_ind,varargin)
% assemble solution using xb, its position index x_ind and xn
[m,n] = size(x_ind); 
%% Input parser
P = inputParser;

% Liste der optionalen Parameter
P.addOptional('par.xn', zeros(n-m,1), @isnumeric) 

% Lese den Input
P.parse(varargin{:});

% Extrahiere die Variablen aus dem Input-Parser
xn = P.Results.xn;

%%
xb = zeropadding(xb,x_ind,par);
xn = zeropadding(xn,x_ind==0,par);

x = xb + xn; 

end