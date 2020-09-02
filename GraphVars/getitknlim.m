function [p1, p2, p3] = getitknlim(m,k,n,ta,tb)
%getitknlim(m,k,n,ta,tb) gets [k,n] from vec m for time > ta & time < tb
kk = [];
nn = [];
for l = m
   k1 = getinterval(ta,tb,l,k);
   n1 = getinterval(ta,tb,l,n);
   kk = [kk;k1];
   nn = [nn;n1];
end
[p,s] = polyfit(kk,nn,1);
nn0 = polyval(p,kk);
delt = nn - nn0;
normresid = std(delt,1)/std(nn,1);
p1 = sprintf( 'LSQ linear coefficients: %0.5g   %0.5g',p(1),p(2) );
p2 = sprintf( 'LSQ normalized residual: %0.5g',normresid );
r = corrcoef(kk,nn);
p3 = sprintf( 'Correlation coefficient: %0.5g',r(1,2));