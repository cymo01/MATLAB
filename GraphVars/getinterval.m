function dvec = getinterval(ta, tb, m, n)
%getinterval(ta,tb,m,n) gets nth col of dataoutm for time > ta & time < tb
datt = [];
datn = [];
datnlim = [];
if m >= 1 & m <= 50
   strm = int2str(m);
   sf1 = ['load data' strm '.mat' ];
   eval(sf1);
   sf1a = ['x = size(dataout' strm ');'];
   eval(sf1a);
   if n >= 1 & n <= x(2)
     sf2 = ['datt = dataout' strm '(:,1);'];
     sf3 = ['datn = dataout' strm '(:,n);'];
     eval(sf2);
     eval(sf3);
     for tindex = 1:length(datt)
        if datt(tindex) > ta & datt(tindex) < tb
           datnlim = [datnlim; datn(tindex)];
        end
     end
   end  
end   
dvec = datnlim;
