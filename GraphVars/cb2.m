function cb2(action)
% callbacks for choosevars
global BOXSTATE

switch(action)
   case 'f0'
      BOXSTATE = zeros(1,30);
   case {       'c2'  'c3'  'c4'  'c5'  'c6'  'c7'  'c8'  'c9'  'c10'...
          'c11' 'c12' 'c13' 'c14' 'c15' 'c16' 'c17' 'c18' 'c19' 'c20'...
          'c21' 'c22' 'c23' 'c24' 'c25' 'c26' 'c27' }
      BOXSTATE(stval(action)) = get(gcbo,'Value');
   case 'p1'
      v = find(BOXSTATE == 1);
      if length(v) < 10
         close(gcbf);
         graphvars(v);
      else
         msgbox(['You must choose fewer than 10 variables'],...
         'ERROR','error','modal')  
      end   
end
 
function n = stval(str)
% Gets current check box number from callback 'action' string
x = str;
x(1) = [];
n = eval(x);
