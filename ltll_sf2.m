function [sys,x0,str,ts] = ltll_sf2(t,x,u,flag)

%SFUNTMPL General M-file S-function template
%   With M-file S-functions, you can define you own ordinary differential 
%   equations (ODEs), discrete system equations, and/or just about
%   any type of algorithm to be used within a Simulink block diagram.

%   Copyright (c) 1990-97 by The MathWorks, Inc.
%   $Revision: 1.9 $
%
switch flag,

  %%%%%%%%%%%%%%%%%%
  % Initialization %
  %%%%%%%%%%%%%%%%%%
  case 0,
    [sys,x0,str,ts]=mdlInitializeSizes;

  %%%%%%%%%%%%%%%
  % Derivatives %
  %%%%%%%%%%%%%%%
  case 1,
    sys=mdlDerivatives(t,x,u);

  %%%%%%%%%%
  % Update %
  %%%%%%%%%%
  case 2,
    sys=mdlUpdate(t,x,u);

  %%%%%%%%%%%
  % Outputs %
  %%%%%%%%%%%
  case 3,
    sys=mdlOutputs(t,x,u);

  %%%%%%%%%%%%%%%%%%%%%%%
  % GetTimeOfNextVarHit %
  %%%%%%%%%%%%%%%%%%%%%%%
  case 4,
    sys=mdlGetTimeOfNextVarHit(t,x,u);

  %%%%%%%%%%%%%
  % Terminate %
  %%%%%%%%%%%%%
  case 9,
    sys=mdlTerminate(t,x,u);

  %%%%%%%%%%%%%%%%%%%%
  % Unexpected flags %
  %%%%%%%%%%%%%%%%%%%%
  otherwise
    error(['Unhandled flag = ',num2str(flag)]);

end

%
%=============================================================================
% mdlInitializeSizes
% Return the sizes, initial conditions, and sample times for the S-function.
%=============================================================================
%
function [sys,x0,str,ts]=mdlInitializeSizes

sizes = simsizes;

% ChE 0500
sizes.NumContStates  = 1; % number of ordinary differential
                          % equations in the model
sizes.NumDiscStates  = 0; % number of discrete difference equations
                          % in the model [typically 0 for ChE 0500/0501]
sizes.NumOutputs     = 1; % number of outputs FROM THE S-FUNCTION.
                          % this is equal to the number of
                          % measured variables plus any other
                          % outputs you want to yield.
sizes.NumInputs      = 3; % number of inputs TO THE S-FUNCTION
                          % this is equal to the number of
                          % manipulated variables plus the number
                          % of disturbance variables, plus the
                          % number of (constant) parameter values
                          % you are passing to the model
sizes.DirFeedthrough = 0; % value 0, if u(i) does NOT appear in the
                          % output block (flag = 3); value 1 if
                          % u(i) (for any i) IS used in the output block
sizes.NumSampleTimes = 1; % number of sample times [typically 1 for 500/501]

sys = simsizes(sizes);

%
% ChE 0500:  initial values for the ordinary differential equations
%
x0  = [6.5]; % initial height

%
% str is always an empty matrix
%
str = [];

%
% initialize the array of sample times
%
ts  = [0];
end
% end mdlInitializeSizes

%
%=============================================================================
% mdlDerivatives
% Return the derivatives for the continuous states.
%=============================================================================
%
function sys=mdlDerivatives(t,x,u)

% ChE 0500:  assign parameter values here
Ac = pi*(9^2); % in^2
d = 1.5; % in
ggc = 32.174*12; % in/s^2
Ad = pi*(0.5^2);

%p = 0.8;
%Cv=1.19*sqrt(ggc);

% ChE 0500:  then specify state definitions - this section remains
%            as comments but is good for remembering what things are
  % input (u) and state (x) assignment
  % u(1) = 
  % u(2) = 
  % and so on
  % x(1) = 
  % x(2) = 
  % and so on

  Fin = u(1); % Flow rate in  
  Cv = u(2); % Cv value
  p = u(3); % exponential factor
  h = x(1); % height
  
% ChE 0500:  finally, write ordinary differential equations
  % dx(1) = 
  % and so on
  % 3.85 (in3/s)/gpm
  dx(1) = (1/Ac)*((Fin*3.85)-(0.2313*sqrt(ggc))*(h-d)^0.3928)-(Cv*sqrt(ggc)*h^p)/Ac;
  sys=dx;
end

% end mdlDerivatives

%
%=============================================================================
% mdlUpdate
% Handle discrete state updates, sample time hits, and major time step
% requirements.
%=============================================================================
%
function sys=mdlUpdate(t,x,u)

sys = [];
end
% end mdlUpdate

%
%=============================================================================
% mdlOutputs
% Return the block outputs.
%=============================================================================
%
function sys=mdlOutputs(t,x,u)

% ChE 0500:  place outputs here - x means all states (ODEs)
sys = [x];
end
% end mdlOutputs

%
%=============================================================================
% mdlGetTimeOfNextVarHit
% Return the time of the next hit for this block.  Note that the result is
% absolute time.  Note that this function is only used when you specify a
% variable discrete-time sample time [-2 0] in the sample time array in
% mdlInitializeSizes.
%=============================================================================
%
function sys=mdlGetTimeOfNextVarHit(t,x,u)

sampleTime = 1;    %  Example, set the next hit to be one second later. 
sys = t + sampleTime;
end
% end mdlGetTimeOfNextVarHit

%
%=============================================================================
% mdlTerminate
% Perform any end of simulation tasks.
%=============================================================================
%
function sys=mdlTerminate(t,x,u)

sys = [];
end
% end mdlTerminate
end
