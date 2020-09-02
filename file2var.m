function Data=file2var(Filename)
% Filename: FILE2VAR.M
%
%   Format: Data=file2var(Filename)
%
%           Data      -  Content in the file
%           Filename  -  Path and filename of a particular file
%
%   Usages: To load data from a particular file and assign the contents 
%           to a pre-defined variable. This script can be used in MATLAB
%           PC and UNIX version.
%
%   Remark: If the file is non-exist, NaN will be returned.

%   Author: Mr. Alexander K. M. Leung
%  Address: The Hong Kong Polytechnic University
%           Dept. of Applied Biology & Chemical Technology
%           Hung Hom, Kowloon, Hong Kong.
%
%   E-mail: kmleung@fg702-6.abct.polyu.edu.hk
%
%     Date: 14-05-1996
%  Version: 1.1 (Updated at 25-06-1997)

% Variable Lists
% ========================================================================
% i, j           - General purpose counter
% m, n           - Size of varibale
% Data           - Content in the file
% Filename       - File name of a particular file
% TempStr        - Temporary string variable

% Main Program
i=find(Filename=='.');
if isunix==1
   j=find(Filename=='/');
else
   j=find(Filename=='\');
end
if length(Filename)<=2
   TempStr=['Error in loading file.'];
   disp(TempStr)
   Data=NaN;
   break;
end
if exist(Filename)==2
   load(Filename,'-ascii');
   if isempty(j)
      if isempty(i)
         Data=eval(Filename);
      else
         Data=eval(Filename(1:(i-1)));
      end
   else
      [m n]=size(j);
      if isempty(i)
         Data=eval(Filename(j(m,n)+1:length(Filename)));
      else
         Data=eval(Filename(j(m,n)+1:(i-1)));
      end
   end
else
   TempStr=sprintf('The file %s is not exist.',Filename);
   disp(TempStr)
   Data=NaN;
end
