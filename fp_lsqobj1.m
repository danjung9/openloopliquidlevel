function [f] = fp_lsqobj1(pvec)

load fitci

% pvec - vector of parameters we are solving for
% tyd - tydata

tyd = pass.tydata;

% define parameters used in simulink diagram
Cv = pvec(1);
p = pvec(2);

% define input to simulation to address changing value of UA at each
% iteration of the optimization
% format (by column):  [time parameter1 parameter2 ...]
% format (rows):  minimimum 2 needed for start and stop times
% CAUTION:  MATLAB will interpolate/extrapolate; if you have different
% values on consecutive rows, MATLAB will use a straight line between those
% parameter values (ramp, not a step)

input=[tyd(1,1) Cv p;tyd(size(tyd,1),1) Cv p];

% set necessary simulation options
simopts = simset('SrcWorkspace','current','OutputPoints','specified','solver','ode23s');
% run simulation and generate data at specified points
%[t,x,y] = sim('openloop501_sim',[tyd(:,1)],simopts,input); %Matlab v.2021
[output]=sim('openloop501_sim',[tyd(:,1)],simopts,input); %first input is the block diagram .mdl file

t=output.tout;
y=output.h;

% calculate residual error vector - data minus model prediction
e1 = (tyd(:,2)-y(:,1)); %Matlab v.2021
% stack all errors into a single vector (lsqnonlin requirement)
e = [e1];
% objective:  residual error
f = e;
