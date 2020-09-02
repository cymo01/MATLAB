function fftitklim(m,k,ta,tb)
%plotitklim(m,k,ta,tb) is fftitk(m,k) for time > ta & time < tb
figure;
hold on;
for l = m
   fftitklim2(l,k,ta,tb);
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

function fftitklim2(m,k,ta,tb)
%fftitklim2(m,k,ta,tb) does fft for time > ta & time < tb
plotvk = getinterval(ta,tb,m,k);
afft = log(abs(fft(plotvk)));
afft = afft(1:floor(length(afft)/2));
plot((0:(length(afft)-1))/length(afft),afft,'.');
sx1 = char(labs(k))';
sx = reshape(sx1,prod(size(sx1)),1)';
%xlabel(sx);
ylabel(['log |FFT(x)|' '     x = ' sx]);