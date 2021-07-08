%
% Problem: To have a second Python script to play with
% Target Users: Me
% Target System: Windows
% Interface: Matlab Command Line
% Functional Requirements: TBD
% Testing: TBD
% Maintainer: Kem White
% Date: 20210621

%  This is a simple Matlab script. I wrote it after Jeff Barton gave the project to the ASPIRE
%   interns to do. They could code this in the programming language of their choice. I used Matlab
%    1. Generate 1000 random numbers with N(0,1), N(10,2), N(5,20), and N(20, 1)
%    2. Output them to a file.
%    3. Open the file and read in the numbers.
%    4. Plot the random numbers after they are read in.
%
outVec=[randn(1000,1), 10+2*randn(1000,1) , 5+20*randn(1000,1) , 20+randn(1000,1)];
fid=fopen('randomNumbers.txt','w');
fprintf(fid,'%10.6f %10.6f %10.6f %10.6f\n',outVec);
fclose('all');

fid=fopen('randomNumbers.txt','r');
inVec=fscanf(fid,'%f', [1000 4]);

absc=(0:1:999)';
plot(absc,inVec(:,1),absc,inVec(:,2));
hold;
plot(absc,inVec(:,3),absc,inVec(:,4));
grid;
fclose('all');
