function histsumlim(mv,n,k,ta,tb)
%histsumlim(m,n,k,ta,tb) does histsum(m,n,k) for time > ta & time < tb 
data = [];
for mi = 1:length(mv)
   limdat = getinterval(ta,tb,mi,n);
   data = [data;limdat];
end
hist(data,k);
histsz = length(data);
sx1 = char(labs(n))';
sx = reshape(sx1,prod(size(sx1)),1)';
xlabel(sx);
ylabel(['number out of ' int2str(histsz) ' in ' int2str(k) ' bins between t = '...
      int2str(ta) ' and t = ' int2str(tb) ]);
if min(mv) ~= max(mv)
   st = ['datasets ' int2str(min(mv)) ' to ' int2str(max(mv))];
else
   st = ['dataset ' int2str(mv) ];
end   
title(st);