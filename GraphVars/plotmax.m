function plotmax(m,k,n,ta,tb)
%plotitknlim(m,k,n,ta,tb) is plotitkn(m,k,n) for time > ta & time < tb
figure;
hold on;
for l = m
   plotitknlim2(l,k,n,ta,tb);
end
hold off;
if min(m) ~= max(m)
   st = ['datasets ' int2str(min(m)) ' to ' int2str(max(m)) ...
         ' between t = ' int2str(ta) ' and t = ' int2str(tb) ];
else
   st = ['dataset ' int2str(m) ...
         ' between t = ' int2str(ta) ' and t = ' int2str(tb) ];
end   
title(st);

function plotitknlim2(m,k,n,ta,tb)
%  
%plotitknlim2(m,k,n,ta,tb) is plotitkn2(m,k,n) for time > ta & time < tb
plotvn = getinterval(ta,tb,m,n);
plotvk = getinterval(ta,tb,m,k);
%
%  Here to change plot line style
%
plot(plotvk,plotvn,'-');
sx1 = char(labs(k))';
sx = reshape(sx1,prod(size(sx1)),1)';
xlabel(sx);
sy1 = char(labs(n))';
sy = reshape(sy1,prod(size(sy1)),1)';
ylabel(sy);
mxk = max(plotvk);
mnk = min(plotvk);
nearmaxk = find(plotvk > mnk + (mxk - mnk)*0.99);
%
% Uncomment following 3 plot stmts to show 
% max and min    dkw
% plot(plotvk(nearmaxk),plotvn(nearmaxk),'bx');
mxn = max(plotvn);
mnn = min(plotvn);
nearmaxn = find(plotvn > mnn + (mxn - mnn)*0.99);
% plot(plotvk(nearmaxn),plotvn(nearmaxn),'k+');
nearmax = intersect(nearmaxk,nearmaxn);
% plot(plotvk(nearmax),plotvn(nearmax),'r*');