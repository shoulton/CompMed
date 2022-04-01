function start
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Starting script to the module 'SIR models of epidemics'
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Implements the basic SIR model, and plots simulation results

%-------------------------------------------------------------------------
% User Section 1: Definition of model parameters
%-------------------------------------------------------------------------
%
% These parameters are passed to the function that calculates the
% derivatives.
%
% NOTE: Do not change the name 'param'!
%
param.beta = 0.00218; % set the parameter 'beta' of the model
param.r = 0.44036;    % set the parameter 'r' of the model

% This is the title string for the plot window.
model_title = 'SIR Epidemics';

%-------------------------------------------------------------------------
% User Section 2: Definition of initial conditions
%-------------------------------------------------------------------------
%
% Initial conditions are the values of all variables at time zero.
%
% NOTE: Do not change the name 'initial'! Define the initial values
%       in the same order as the derivatives
%
initial.S = 762;	% set the initial value of 'S'
initial.I = 1;	% set the initial value of 'I'
initial.R = 0;	% set the initial value of 'R'

%-------------------------------------------------------------------------
% User Section 3: Definition of the simulation time
%-------------------------------------------------------------------------
end_time = 20;

%-------------------------------------------------------------------------
% User Section 4: Definition of the ODE system
%-------------------------------------------------------------------------
function deriv = ode_system (t, x, param)
% Function to calculate derivatives of the SIR model
%
% Input:
%       t:     Time (not used in this example because there is no explicit
%              time dependence).
%       x:     Vector of the current values of all variables in the same
%              order as you defined the inital values: S, I, R
%       param: Used to pass parameter values.
% Output:
%       deriv: Column vector of derivatives, must be the same order as the
%              input vector x.

S = x(1);
I = x(2);
R = x(3);
dS = -param.beta * S * I;
dI = +param.beta * S * I - param.r * I;
% Note: because S+I+R=constant, this equation could actually be omitted,
% and R at any time point could simply be calculated as N-S-I.
dR = param.r * I;
deriv = [dS; dI; dR];
end

%-------------------------------------------------------------------------
% Now we solve the ODE system and plot the results
%-------------------------------------------------------------------------

% Calculate and print R_0 on the screen
N = initial.S + initial.R + initial.I;
%R_0 = param.beta * N / param.r

% Extract initial values from the 'initial' structure and collect them
% in a column vector for use in 'ode45'.
initial_values = [];
variable_names = fieldnames(initial);
for i=1:length(variable_names) 
    initial_values = [initial_values; initial.(variable_names{i})];
end

% integrate the ODE system
[t, y] = ode45(@(t, x) ode_system(t, x, param), ...
               [0 end_time], ...
               initial_values, ...
               []);

% prepare legend texts
legend_texts = cell(length(variable_names), 1);
for i=1:length(variable_names) 
    text = [variable_names{i} '(t)'];
    legend_texts{i} = text;
end

% plot the results
figure()
plot(t, y(:,1));
xlabel('time');
ylabel('number of individuals');
xticks([0 5 10 15 20 25])
title(model_title);
legend(legend_texts(1));

figure()
plot(t, y(:,2));
xlabel('time');
ylabel('number of individuals');
xticks([0 5 10 15 20 25])
title(model_title);
legend(legend_texts(2));

figure()
plot(t, y(:,3));
xlabel('time');
ylabel('number of individuals');
xticks([0 5 10 15 20 25])
title(model_title);
legend(legend_texts(3));

end
