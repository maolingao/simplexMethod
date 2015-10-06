function indx = findindx(x,i,varargin)
% find the global index in a vector, where the i-th element which equals
% the number specificed in 'target_num'.
% default target_num = 0

%% Input parser
P = inputParser;

% List of the optional parameters
P.addOptional('target_num',0, @isnumeric);

% read out the Inputs
P.parse(varargin{:});

% Extract the variabls from the Input-Parser
target_num = P.Results.target_num;

%% 
target_indx_vec = find(x == target_num);
indx = target_indx_vec(i);

end