% PlotLatLon.m
%

% figure;
clear UTMEasting UTMNorthing
for i=1:length(Lat_deg),
	 [UTMEasting(i) UTMNorthing(i)]=wgs84_to_utm(Lat_deg(i),Lon_deg(i),0);
end
    plot(UTMEasting,UTMNorthing,'b-'); 
	xlabel('UTM Easting, m'); 
	ylabel('UTM Northing, m'); 
	grid on; 
%	axis equal