#include "ned.h"

M<double> dtr("dtr",0,0); M<double> cos80("cos80",0,0); M<double> sin80(\
  "sin80",0,0); M<double> cneddcd("cneddcd",0,0); M<double> i("i",0,0); M<double> \
  i_v0("i_v0",0,0); M<double> dcd("dcd",0,0); 

dtr=pi/180.0;
cos80=cos(80.0*dtr);
sin80=sin(80.0*dtr);
cneddcd=(BR(cos80),-sin80,semi,sin80,cos80);
i_v0=colon(1.0,1,200.0);
for (int i_i0=1;i_i0<=forsize(i_v0);i_i0++) {
  forelem(i,i_v0,i_i0);
  dcd(i,1.0)=cneddcd(1.0,1.0)*ned(i,1.0)+cneddcd(1.0,2.0)*ned(i,2.0);
  dcd(i,2.0)=cneddcd(2.0,1.0)*ned(i,1.0)+cneddcd(2.0,2.0)*ned(i,2.0);
}
