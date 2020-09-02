function [lat2,lon2] = GeoDirect(lat1,lon1,range,heading,ellipsoid)
%GeoDirect
% Solves the direct geodetic problem:  finds the latitude and 
% longitude of a second point given the latitude and longitude of 
% the first point, a range and the bearing from the first to second
% point.
%
% Usage:  [lat2,lon2] = GeoDirect(lat1,lon1,range,heading,ellipsoid)
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
% $Id: GeoDirect.m,v 1.3 2002/01/22 18:54:37 rogerlf1 Exp $

% handle pathological case
if range == 0,
  lat2 = lat1;
  lon2 = lon1; 
  return;
end;

% determine which ellipsoid to use (default is spherical earth)
if (nargin < 5), ellipsoid = 'sphere'; end;
if strcmp(lower(ellipsoid),'wgs84'),
   a = 6378137; finv = 298.257223563;
   [lat2, lon2] = bessel_1(lat1,lon1,heading,range,a,finv);
else
   a = 6371000;
   [lat2, lon2] = distantpoint(lat1,lon1,range,heading,a);
end;

%------------------------------------------
function [lat2,lon2] = distantpoint(lat1,lon1,range,heading,a)
% Uses spherical earth of radius a to computes coordinates at second 
% point given coordinates at first point, range (meters) and heading 
% (deg) from true North. All coordinates are in degrees.
%
% lat1 and lon1 must be scalars. range and heading can be vectors.
% If range or heading is a vector, then lat2 and lon2 are vectors.
% If range and heading are both vectors, then lat2 and lon2 become 
% matrices.
%
% Original version by Bruce Newhall?

nmi_per_degree = (2*pi*a/360)/1852;
range = range*100/2.54/12/6076.1; % convert input "range" from meters to nmi
conv = pi/180;
heading = conv*heading;
lat1 = conv*lat1;
lon1 = conv*lon1;
alpha = conv*range/nmi_per_degree;
s = sign(sin(heading));

ca = cos(lat1);
sa = sin(lat1);

lat2 = cos(heading)'*sin(alpha).*ca;
lat2 = lat2+ones(length(heading),1)*(sin(lat1).*cos(alpha));
lat2 = asin(lat2);

lon2 = ones(length(heading),1)*cos(alpha)-sa*sin(lat2);
lon2 = lon2./(ca*cos(lat2));
lon2 = lon1+(s'*ones(1,length(range))).*acos(lon2);

lat2 = real(lat2 / conv);
lon2 = real(lon2 / conv);

%------------------------------------------
function [phi2,l2] = bessel_1(phi1,l1,A1,s12,a,finv)
%BESSEL_1 Solution of the direct geodetic problem according to
%         the Bessel-Helmert method as described in Zhang Xue-Lian.
%         Given a point with coordinates (phi1, l1) and 
%         a gedesic with azimuth A1 and length s12 from here. The 
%         given reference ellipsoid has semi-major axis a and 
%         inverse flattening finv. 
%
%         Zhan Xue-Lian (1985): The nested coefficient method
%            for accurate solutions of direct and inverse geodetic
%            problems with any length. In proceedings of the 7th
%            International Symposium on Geodetic Computations, 
%            Cracow, June 18--21, 1985. Pages 747--763. Institute
%            of Geodesy and Cartography. Wasaw, Poland, ul. Jasna 2/4.
%
%         A good decription of the general background of the problems
%         is given in
%
%  	    Bodem\"uller, H.(1954): Die geod\"atischen Linien des 
%	          Rotationsellipsoides und die L\"osung der geod\"atischen
%	          Hauptaufgaben f\"ur gro\ss{}e Strecken unter 
%            besonderer Ber\"ucksichtigung der Bessel-Helmertschen
%            L\"osungsmethode. Deutsche Geod\"atische Kommission,
%            Reihe B, Nr. 13.

%Kai Borre, January 24, 1999
%Copyright (c) by Kai Borre
%$Revision 1.0 $  $Date: 2002/01/22 18:54:37 $

% set tolerance for convergence
myeps = eps;

% convert input latitude, longitude and azimuth to radians
phi1 = pi/180*phi1;
l1 = pi/180*l1;
A1 = pi/180*A1;

% now compute away
f = 1/finv; 
ex2 = (2-f)*f/(1-f)^2;	        % second eccentricity squared
tanu1 = (1-f)*tan(phi1);        % (1)
sigma1 = atan2(tanu1,cos(A1));  % (2)
u1 = atan(tanu1);
cosun = cos(u1)*sin(A1);        % (3)
sinun2 = 1-cosun^2;
t = ex2*sinun2/4;               % (4)
K1 = 1+t*(1-t*(3-t*(5-11*t))/4);
K2 = t*(1-t*(2-t*(37-94*t)/8));
v = f*sinun2/4;                 % (5)
K3 = v*(1+f+f^2-v*(3+7*f-13*v));
deltasigma_old = 0;
deltasigma_new = 1;

while  abs(deltasigma_old-deltasigma_new) > myeps,
   deltasigma_old = deltasigma_new;
   sigma = s12/(K1*(1-f)*a)+deltasigma_old; % (6)
   sigmam = 2*sigma1+sigma;
   deltasigma_new = K2*sin(sigma)*(cos(sigmam)+...
                      K2*(cos(sigma)*cos(2*sigmam)+...
                        K2*(1+2*cos(2*sigma))*cos(3*sigmam)/6)/4); %(7)
end

tanu2 = (sin(u1)*cos(sigma)+cos(u1)*sin(sigma)*cos(A1))/...
                           sqrt(1-sinun2*(sin(sigma1+sigma))^2); %(8)
phi2 = atan(tanu2/(1-f));
deltaomega = (1-K3)*f*cosun*(sigma+...
               K3*sin(sigma)*(cos(sigmam)+...
               K3*cos(sigma)*cos(2*sigmam))); % (9)
omega = atan2(sin(sigma)*sin(A1),...
               cos(u1)*cos(sigma)-sin(u1)*sin(sigma)*cos(A1)); % (10)
l2 = l1+omega-deltaomega;
A2 = atan2(cos(u1)*sin(A1),...
               cos(u1)*cos(sigma)*cos(A1)-sin(u1)*sin(sigma)); % (11)             

% convert output latitude, longitude and azimuth to degrees
phi2 = 180/pi*phi2;
l2 = 180/pi*l2;
A2 = 180/pi*A2;
%----------------------------------------------
