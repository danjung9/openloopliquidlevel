% data file - 1st column is time, 5th col. is tank height
%load day1.mat
load day2.mat
%day11=day1(500:4024,[1,5]); %select data for parameters estimation
day11=day2(3497:5040,[1,5]);
%%
% parameter initial guess
params=[0.1 0.87]; %guess Cv=.1, p= 0.87

optoptions = optimset('Display','iter');
% constraints on the parameter(s)
lsqlb = 0 * params; % lower bound, assumed zero
lsqub = inf * params; % upper bound, assumed "unbounded"

% read 'help lsqnonlin' for assistance w/ this call
day11 = table2array(day11); % convert table to array
pass.tydata = day11; 
tydata = day11;

save fitci pass
[lnX,lnRESNORM,lnRESIDUAL,lnEXITFLAG,lnOUTPUT,lnLAMBDA,lnJACOBIAN]=lsqnonlin(@fp_lsqobj1,params,lsqlb,lsqub,optoptions);
lnX
% calculate confidence intervals for the estimated parameters
CIBETA = nlparci(lnX,lnRESIDUAL,'jacobian',lnJACOBIAN)

% assign final parameter values
Cv = lnX(1);
p = lnX(2);
siminput=[tydata(1,1) Cv p;tydata(size(tydata,1),1) Cv p];

% set necessary simulation options
simopts = simset('SrcWorkspace','current','OutputPoints','specified');
% run simulation and generate data at specified points
%Matlab v. 2021
%[t,x,y]=sim('openloop501_sim',[tydata(:,1)],simopts,siminput); %first input is the block diagram .mdl file
[output]=sim('openloop501_sim',[tydata(:,1)],simopts,siminput); %first input is the block diagram .mdl file

t=output.tout;
y=output.h;

% Tank height
subplot(211);
plot(tydata(:,1),tydata(:,2),'ro');
hold;
%plot(t,y(:,1),'b-'); %Matlab v.2021
plot(t,y,'b-');
xlabel('Time (min)');
ylabel('Height')
hold;


