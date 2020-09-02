function sortplot(mv,nx,ny,k,ta,tb)
%sortplot(m,nx,ny,k,ta,tb)
datax = [];
datay = [];
bins = k;
for mi = 1:length(mv)
   limdatx = getinterval(ta,tb,mi,nx);
   datax = [datax;limdatx];
   limdaty= getinterval(ta,tb,mi,ny);
   datay  = [datay;limdaty];
end
[xsort xindex] = sort(datax);
ysort = datay(xindex);
a = polyfit(xsort,ysort,1);
yred = ysort - a(1)*xsort - a(2);
lred = length(yred);
xmn = min(xsort);
xmx = max(xsort);
delx = (xmx - xmn)/bins;
l = [];
ym = [];
ys = [];
xvals = (( 1:2*bins ) - 0.5 + xmn/delx)*delx;
xvals0 = xvals(1:bins);
for k = 1:bins
   xa = xmn + (k-1)*delx;
   xb = xa + delx;
   xint = find(xsort > xa & xsort < xb);
   l = [l length(xint)];
   yint = yred(xint);
   if length(yint) ~= 0
      ym = [ym mean(yint)];
      ys = [ys std(yint,1)];
   else
      xvals(k) = [];
   end   
end
yvals = 1:length(ym);
xvals = xvals(yvals);
figure;
subplot(2,2,1);plot(xsort,yred,'.');
title('De-trended points y vs. x');
subplot(2,2,2);plot(xvals0,l);
title('Number per x-axis bin vs. x');
subplot(2,2,3);plot(xvals,ym);
title('Avg y-vals in bins vs. x');
subplot(2,2,4);plot(xvals,ys);
title('STD of y-vals in bins vs. x');
set(gcf,'Position',get(gcf,'Position') - [100 100 -100 -100]);
