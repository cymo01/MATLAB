idexhiprod=find(dpprod>=5.6);
idexloprod=find(dpprod<5.6);
epshiprod=-0.2955*(dpprod(find(dpprod>=5.6))-5.6)+1.3;
epsloprod=dpprod(find(dpprod<5.6)).*(dpprod(find(dpprod<5.6)).*(-.0038*dpprod(find(dpprod<5.6))+0.2770)-2.9049)+9.5469;

idexhilow=find(dplow>=5.6);
idexlolow=find(dplow<5.6);
epshilow=-0.2955*(dplow(idexhilow)-5.6)+1.3;
epslolow=dplow(idexlolow).*(dplow(idexlolow).*(-.0038*dplow(idexlolow)+.2770)-2.9049)+9.5469;

idexhiupper=find(dpupper>=5.6);
idexloupper=find(dpupper<5.6);
epshiupper=-0.2955*(dpupper(idexhiupper)-5.6)+1.3;
epsloupper=dpupper(idexloupper).*(dpupper(idexloupper).*(-.0038*dpupper(idexloupper)+.2770)-2.9049)+9.5469;

figure;hold;

plot([dpprod(idexloprod) dpprod(idexhiprod)],[epsloprod epshiprod],'b');
plot([dplow(idexlolow) dplow(idexhilow)],[epslolow epshilow],'g');
plot([dpupper(idexloupper) dpupper(idexhiupper)],[epsloupper epshiupper],'r');

% plot(dplow(idexhilow),epshilow,'g',dplow(idexlolow),epslolow,'g');
% plot(dpupper(idexhiupper),epshiupper,'r',dpupper(idexloupper),epsloupper,'r');

grid;

title('Radial Misalignment');
xlabel('DP1, DY1');ylabel('EPSP, EPSY');