freq1 = 200.;
freq2 = 40.;
deltat=1/2.;      
phase1=0;
phase2=0;
i=[0:3999]';
t=deltat*i;
a=1.5*cos(2*pi*freq1*t+phase1) + 0.25*cos(2*pi*freq2*t+phase2);
plot(t,a);

  