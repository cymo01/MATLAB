dtr=pi/180;
cos80=cos(80*dtr);
sin80=sin(80*dtr);
cneddcd=[cos80 -sin80
         sin80  cos80];
for i=1:200,
  dcd(i,1)=cneddcd(1,1)*ned(i,1)+cneddcd(1,2)*ned(i,2);
  dcd(i,2)=cneddcd(2,1)*ned(i,1)+cneddcd(2,2)*ned(i,2);
end
