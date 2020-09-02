function cb1(action,VKN)
%graphvars gui callbacks
global XSTATE YSTATE SETSTR TSTART TEND BINS VK

%-------------------- INIT LOCAL VARIABLES ----------------------
% Arrays of radio button and text 'Tag' strings
rbx = {'Radiox1' 'Radiox2' 'Radiox3' 'Radiox4' 'Radiox5' 'Radiox6' ...
       'Radiox7' 'Radiox8' 'Radiox9' 'Radioxt' 'Radioxf'};
rby = {'Radioy1' 'Radioy2' 'Radioy3' 'Radioy4' 'Radioy5' 'Radioy6' ...
      'Radioy7' 'Radioy8' 'Radioy9' 'Radioyh' };
tx  = {'textx1' 'textx2' 'textx3' 'textx4' 'textx5'...
       'textx6' 'textx7' 'textx8' 'textx9' 'textxt' };
ty  = {'texty1' 'texty2' 'texty3' 'texty4' 'texty5'...
       'texty6' 'texty7' 'texty8' 'texty9' 'textyt' };
% disambiguating different uses of '1' (see PLOT callback)
timeplot = 1;
histplot = 1;
fftplot  = 0;

%---------------------- CALLBACKS -------------------------------
switch(action)
% Figure creation callback 
%   Does inits of callback radio button states and edit strings
%   VK is array of data column numbers that can be plotted   
   case 'f1'
      XSTATE = 1;
      YSTATE = 2;
      SETSTR = '1';
      TSTART = '0';
      TEND   = '100';
      BINS   = '40';
      VK = [2 3 4 5 6 7 8 9 10 1 0]; 
% Initialization callback sets gui states equal to callback states  
   case 'i0'
   % Change variables to be graphed, if desired
      if nargin == 2 & length(VKN) < (length(VK)-1)
         VK(1:length(VKN)) = VKN;  
      end 
   % Set radio button states   
      for k = 1:length(rbx)
         set(findobj('Tag',char(rbx(k))),'Value',0);
      end
      for k = 1:length(rby)
         set(findobj('Tag',char(rby(k))),'Value',0);
      end;   
      set(findobj('Tag',char(rbx(XSTATE))),'Value',1);
      set(findobj('Tag',char(rby(YSTATE))),'Value',1);
    % Set edit box states  
      set(findobj('Tag','EditText1'),'String',SETSTR);
      set(findobj('Tag','EditText2'),'String',TSTART);
      set(findobj('Tag','EditText3'),'String',TEND);
      set(findobj('Tag','EditText4'),'String',BINS);
    % Set radio button label states  
      for k = 1:(length(VK)-1)
         set(findobj('Tag',char(tx(k))),'String',labs1(VK(k)));
         set(findobj('Tag',char(ty(k))),'String',labs1(VK(k)));
      end   
 % Radio button callbacks: 
 %     old gui state = 0, current gui state = 1, update callback state      
   case {'x1' 'x2' 'x3' 'x4' 'x5' 'x6' 'x7' 'x8' 'x9' 'x10' 'x11' }               
      set(findobj('Tag',char(rbx(XSTATE))),'Value',0);
      set(gcbo,'Value',1);
      XSTATE = stval(action);
   case {'y1' 'y2' 'y3' 'y4' 'y5' 'y6' 'y7' 'y8' 'y9' 'y10' }
      set(findobj('Tag',char(rby(YSTATE))),'Value',0);  
      set(gcbo,'Value',1);
      YSTATE = stval(action);
% Edit box callbacks with checking for valid 'eval'-able input strings     
   case 't1'
      SETSTR = checkstring(SETSTR);
   case 't2'
      TSTART = checkstring(TSTART);
   case 't3'
      TEND   = checkstring(TEND);
   case 't4'
      BINS   = checkstring(BINS);
% PLOT VALUES pushbutton callback      
   case 'p1'
   % Get parameters from edit strings, trapping errors with evalstrings
      [svec ti tf bns theresaproblem] = ...
            evalstrings(SETSTR,TSTART,TEND,BINS);
      if theresaproblem
         msgbox('There is an error in an edit box','ERROR','error')
      elseif VK(YSTATE)~= histplot
      % Plot or fft data   
         if VK(XSTATE) ~= fftplot
            plotmax(svec,VK(XSTATE),VK(YSTATE),ti,tf);
         else           
            fftitklim(svec,VK(YSTATE),ti,tf); 
         end
      % Histogram data   
      elseif VK(YSTATE) == histplot & VK(XSTATE) ~= timeplot ...
                                    & VK(XSTATE) ~= fftplot
         figure;   
         histsumlim(svec,VK(XSTATE),bns,ti,tf);
      end
% CALCULATE pushbutton callback      
   case 'p3'
    % Get parameters from edit strings, trapping errors with evalstrings
      [svec ti tf bns theresaproblem] = ...
            evalstrings(SETSTR,TSTART,TEND,BINS);
      if theresaproblem
         msgbox('There is an error in an edit box','ERROR','error')
     % Clear old params, get new ones, print new ones
      elseif VK(YSTATE)~= histplot
         delete(gca);      
         axis off;
         [p1,p2,p3] = getitknlim(svec,VK(XSTATE),VK(YSTATE),ti,tf);
         text(0.5,0.40,p1);
         text(0.5,0.35,p2);
         text(0.5,0.30,p3);
      end      
% CLOSE pushbutton callback      
   case 'p2'
      close(gcbf);
% PLOT STATS pushbutton callback      
   case 'p4'
   % Get parameters from edit strings, trapping errors with evalstrings
      [svec ti tf bns theresaproblem] = ...
            evalstrings(SETSTR,TSTART,TEND,BINS);
      if theresaproblem
         msgbox('There is an error in an edit box','ERROR','error')
      % plot and histogram detrended data   
      elseif VK(YSTATE) ~= histplot & VK(XSTATE) ~= fftplot  
         sortplot(svec,VK(XSTATE),VK(YSTATE),bns,ti,tf);
      end      
end

function n = stval(str)
% Gets current radio button number from callback 'action' string
x = str;
x(1) = [];
n = eval(x);

function l = labs1(n)
% Gives text string of variable n
labels = { 
      'TIME'    'distgtn'  'alm'   'alam'  'altmsl'  'etapc'  ...
      'ambm3r'  'acmax'    'phic'  'phi'   'vmach'   'alpha'...
      'terain'  'xtkb'     'cg(2)' 'cg(3)' 'anct'    'vmag' ...
      'vrelm'   'dr'       'theta' 'wght'  'W91'     'wofb' ...
      'wofbofs' 'cg(1)'    'xcg'   'add'  };
l = labels(n);

function newstring = checkstring(oldstring)
% returns new edit string from current callback if there's no error,
% else returns old string
newstring = get(gcbo,'String');
[sval svalerr] = evalerror(newstring);
if svalerr == 1
   msgbox(['Can''t evaluate the string ' '''' newstring ''''],...
      'ERROR','error','modal')
   set(gcbo,'String',oldstring);
   newstring = oldstring;
end

function [v1,v2,v3,v4,e] = evalstrings(s1,s2,s3,s4)
% returns values of strings or error flag
[v1 e1 ] = evalerror(s1);
[v2 e2 ] = evalerror(s2);
[v3 e3 ] = evalerror(s3);
[v4 e4 ] = evalerror(s4);
e = (e1 == 1 | e2 == 1 | e3 == 1 | e4 == 1);

function [sval, errval] = evalerror(s)
% Traps errors in eval(s)
ans = NaN;
sval = NaN;
errval = 0;
eval([s ';'],'errval = 1;');
if errval == 0
   sval = ans;
end