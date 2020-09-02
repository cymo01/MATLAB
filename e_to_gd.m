function y = e_to_gd(x_ECEF)

%x_ECEF is a 3x1 column vector of position in ECEF (ft).
%y is a 3x1 column vector of (geodetic latitude (rad), longitude (rad), height (ft) above WGS-84 Ellipsoid)'.
%See Zhu, "Exact Conversion of Earth-Centered, Earth-Fixed Coordiinates to Geodetic Coordinates", J. Guidance,
%vol.16, no.2., pp. 389-391.
%This formula breaks down if x_ECEF is within 43 km of the Earth center.

%WGS-84 parameters:
m_to_ft = 3937/1200;	%meters to US Survey feet
a = 6378137;		%Ellipsoid semi-major axis (m)
b = 6356752.3142;	%Ellipsoid semi-minor axis (m)
e2 = 0.00669437999013;	%First eccentricity squared (unitless)

x = x_ECEF(1)/m_to_ft; y = x_ECEF(2)/m_to_ft; z = x_ECEF(3)/m_to_ft;

w = sqrt(x^2 + y^2);
l = e2/2; m = (w/a)^2; n = ( (1-e2)*z/b )^2;
i = -(2*l^2 + m + n)/2; k = l^2*(l^2 - m - n);
q = (m + n - 4*l^2)^3/216 + m*n*l^2;
D = sqrt( (2*q - m*n*l^2)*m*n*l^2 );
beta = i/3 - (q + D)^(1/3) - (q - D)^(1/3);
t = sqrt( sqrt(beta^2-k) - (beta+i)/2 ) - sign(m-n)*sqrt( (beta-i)/2 );
w1 = w/(t + l); z1 = (1 - e2)*z/(t - l);

longitude = 2*atan2( (w-x), y );

if (w ~= 0),
	latitude = atan2( z1, ( (1-e2)*w1 ) );
	h = sign(t-1+l)*sqrt( (w-w1)^2 + (z-z1)^2 );
else
	latitude = sign(z)*pi/2;
	h = abs(z) - b;
end

h = h*m_to_ft;
y = [latitude, longitude, h]';


