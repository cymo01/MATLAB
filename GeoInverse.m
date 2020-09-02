function [range,af,ar] = GeoInverse(lat1,lon1,lat2,lon2,ellipsoid);
%GeoInverse
% Solves the inverse geodetic problem:  given the latitude and 
% longitude of two points, computes the range between the two 
% (in meters) as well as the forward and reverse bearings.
% The forward bearing AF is the initial bearing from point 1 to point 2, 
% the reverse bearing AR is the initial bearing from point 2 to point 1.
%
% Usage:  [range,af,ar] = GeoInverse(lat1,lon1,lat2,lon2,ellipsoid);
%
% Latitudes and longitudes are in decimal degrees North and East,
% respectively.  Range is in meters, and heading is measured
% clockwise with respect to North (ie true).  The reference
% ellipsoid can be either 'wgs84' or 'sphere' (the default).  If 
% 'wgs84' is chosen, a much slower (but highly accurate) routine 
% by Kai Borre is used.  If 'sphere' is chosen, a simple (and fast)
% routine is used which assumes a spherical earth of radius 6371.0 km,
% which is the same value assumed in the WHOI routine "dist.m".
% Note:  spherical earth is vectorized; wgs84 is not.

% Lee Rogers <Lee.Rogers@jhuapl.edu>
% $Id: GeoInverse.m,v 1.5 2002/01/22 18:54:57 rogerlf1 Exp $

% handle pathological case
if (lat1 == lat2 & lon1 == lon2),
  range = 0;
  af = NaN;
  ar = NaN;
  return;
end;

% determine which ellipsoid to use (default is spherical earth)
if (nargin < 5), ellipsoid = 'sphere'; end;
if strcmp(lower(ellipsoid),'wgs84'),
   a = 6378137; finv = 298.257223563;
   [range,af,ar] = bessel_2(lat1,lon1,lat2,lon2,a,finv);
else
   a = 6371000;
   [range,af,ar] = greatcircle(lat1,lon1,lat2,lon2,a);
end;

%------------------------------------------
function [r,af,ar] = greatcircle(lat1,lon1,lat2,lon2,a)
% Computes great circle distance (in meters), forward and 
% reverse bearings (wrt true North) given two points on a 
% sphere.  Based on formula shown in Scott Hayek's HP user 
% manual

% $Id: GeoInverse.m,v 1.5 2002/01/22 18:54:57 rogerlf1 Exp $
% LFR 21Apr00

nmi_per_degree = (2*pi*a/360)/1852;
lat1 =  pi/180*lat1(:);
lon1 = -pi/180*lon1(:);   % this code thinks East is negative
lat2 =  pi/180*lat2(:);
lon2 = -pi/180*lon2(:);   % this code thinks East is negative

% compute distance in meters
term1 = sin(lat1).*sin(lat2);
term2 = cos(lat1).*cos(lat2).*cos(lon2-lon1);
rnmi = nmi_per_degree*180/pi.*acos(term1+term2);
r = 1852*rnmi;

% compute bearing from point 1 to point2
term1 = sin(lat2);
term2 = sin(lat1).*cos(rnmi/nmi_per_degree*pi/180);
term3 = sin(rnmi/nmi_per_degree*pi/180).*cos(lat1);
H = real(180/pi.*acos( (term1-term2)./term3 ));
i = find(sin(lon2-lon1) >= 0);
H(i) = 360-H(i);
%*** change per Allan Rosenberg 22Jan02
i = find (H>180);
H(i) = H(i)-360;
%***
af = H;

% compute bearing from point 2 to point 1
term1 = sin(lat1);
term2 = sin(lat2).*cos(rnmi/nmi_per_degree*pi/180);
term3 = sin(rnmi/nmi_per_degree*pi/180).*cos(lat2);
H = real(180/pi.*acos( (term1-term2)./term3 ));
i = find(sin(lon1-lon2) >= 0);
H(i) = 360-H(i);
%*** change per Allan Rosenberg 22Jan02
i = find (H>180);
H(i) = H(i)-360;
%***
ar = H;

%------------------------------------------
function [s12,A1,A2] = bessel_2(phi1,l1,phi2,l2,a,finv)
%BESSEL_2 Solution of the inverse geodetic problem according to
%         the Bessel-Helmert method as described in Zhan Xue-Lian.
%         Given two points with coordinates (phi1, l1) and 
%         (phi2,l2). Per definition we always have l2 > l1.
%         The given reference ellipsoid has semi-major
%         axis a and inverse flattening finv. The coordinates
%         are in the format degree, minute, and second with decimals. 
%
%         Zhan Xue-Lian (1985) The nested coefficient method for
%            accurate solutions of direct and inverse geodetic 
%            problems with any length. Proceedings of the 7th
%            International Symposium on Geodetic Computations.
%            Cracow, June 18--21, 1985. Institute of Geodesy and
%            Cartography. Wasaw, Poland, ul. Jasna 2/4
%
%         For a good background of the problems, see 
%
%  	    Bodem\"uller, H.(1954): Die geod\"atischen Linien des 
%	       Rotationsellipsoides und die L\"osung der geod\"atischen
%	       Hauptaufgaben f\"ur gro\ss{}e Strecken unter 
%         besonderer Ber\"ucksichtigung der Bessel-Helmertschen
%         L\"osungsmethode.
%	       Deutsche Geod\"atische Kommission, Reihe B, Nr. 13.

%Kai Borre, January 25, 1999
%Copyright (c) by Kai Borre
%$Revision 1.0 $  $Date: 2002/01/22 18:54:57 $

% set tolerance for convergence
myeps = eps;

% convert input latitudes and longitudes to radians
phi1 = pi/180*phi1;
phi2 = pi/180*phi2;
l1 = pi/180*l1;
l2 = pi/180*l2;

% force l2 > l1 to meet assumed condition
if l2 < l1,
  switched = 1;
  temp = l1; l1 = l2; l2 = temp;
  temp = phi1; phi1 = phi2; phi2 = temp;
else
  switched = 0;
end;

% compute away
f = 1/finv; 
ex2 = (2-f)*f/(1-f)^2;

%Reduced latitudes
u1 = atan((1-f)*tan(phi1)); 
u2 = atan((1-f)*tan(phi2));
deltaomega_old = 0;
deltaomega_new = 1;

while abs(deltaomega_old-deltaomega_new) > myeps,
   deltaomega_old = deltaomega_new;
   omega = l2-l1+deltaomega_old;
   sigma = atan2(sqrt((cos(u2)*sin(omega))^2+...
      (cos(u1)*sin(u2)-sin(u1)*cos(u2)*cos(omega))^2),...
      sin(u1)*sin(u2)+cos(u1)*cos(u2)*cos(omega)); 
   cosun = cos(u1)*cos(u2)*sin(omega)/sin(sigma);   
   sinun2 = 1-cosun^2;   
   if sinun2 == 0
      sigmam = acos(cos(sigma)-2);
   else
      sigmam = acos(cos(sigma)-2*sin(u1)*sin(u2)/sinun2);   
   end
   v = f*sinun2/4;
   K3 = v*(1+f+f^2-v*(3+7*f-13*v));
   deltaomega_new = (1-K3)*f*cosun*(sigma+K3*sin(sigma)*(cos(sigmam)+...
      K3*cos(sigma)*cos(2*sigmam)));
end

t = ex2*sinun2/4;
K1 = 1+t*(1-t*(3-t*(5-11*t))/4);
K2 = t*(1-t*(2-t*(37-94*t)/8));
deltasigma = K2*sin(sigma)*(cos(sigmam)+...
   K2*(cos(sigma)*cos(2*sigmam)+...
   K2*(1+2*cos(2*sigma))*cos(3*sigmam)/6)/4);
s12 = K1*(1-f)*a*(sigma-deltasigma);
A1 = atan2(cos(u2)*sin(omega),...
   cos(u1)*sin(u2)-sin(u1)*cos(u2)*cos(omega));
A2 = atan2(cos(u1)*sin(omega),...
   cos(u1)*sin(u2)*cos(omega)-sin(u1)*cos(u2));

% convert bearings back to degrees
A1 = 180/pi*A1;
A2 = 180/pi*A2;

% fix forward and reverse bearings
if switched,
  temp = A1; A1 = A2; A2 = temp;
  A1 = A1-180;
else
  A2 = A2-180;
end;
