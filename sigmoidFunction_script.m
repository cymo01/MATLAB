%
%  This script demonstrates the sigmoid function. 
%    The sigmoid function is discussed in the AIAA paper: "Impact Time and
%    Angle Control Guidance," Kumar, S. R. and D. Ghose, AIAA SciTech Forum
%    at the AIAA GNC Conference, 5-9 January 2015. 

%   Example of the sgmf(2) function
%     myA > 0
%
%  The smaller the value fo myA, the more rounded the corners.
%
%% 
myA=20;
xarg=-5:.1:5;
Arg1=exp(-myA*xarg);
Term0= 1./(1+Arg1);    %syntax for elementwise division
sgmf=2*(Term0-0.5);
plot(xarg,sgmf); grid;
%% 
myA=5;
xarg=-5:.1:5;
Arg1=exp(-myA*xarg);
Term0= 1./(1+Arg1);    %syntax for elementwise division
sgmf=2*(Term0-0.5);
hold;
plot(xarg,sgmf);