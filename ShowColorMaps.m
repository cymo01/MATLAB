function ShowColorMaps
% ShowColorMaps shows available Matlab colormaps by cycling through them.
%
% See also COLORMAP and COLORBAR.
%
% TSMAT Toolbox function.

% Uilke Stelwagen, January 1999.
% Copyright (C) 1992-1999, Institute of Applied Physics, TNO-TPD,
% The Netherlands.

map_s = [
   'hsv        - Hue-saturation-value color map.                   '
   'hot        - Black-red-yellow-white color map.                 '
   'gray       - Linear gray-scale color map.                      '
   'bone       - Gray-scale with tinge of blue color map.          '
   'copper     - Linear copper-tone color map.                     '
   'pink       - Pastel shades of pink color map.                  '
   'white      - All white color map.                              '
   'flag       - Alternating red, white, blue, and black color map.'
   'lines      - Color map with the line colors.                   '
   'colorcube  - Enhanced color-cube color map.                    '
   'jet        - Variant of HSV (Matlab default).                  '
   'prism      - Prism color map.                                  '
   'cool       - Shades of cyan and magenta color map.             '
   'autumn     - Shades of red and yellow color map.               '
   'spring     - Shades of magenta and yellow color map.           '
   'winter     - Shades of blue and green color map.               '
   'summer     - Shades of green and yellow color map.             '
];

figure,h=subplot(132);colorbar(h);title(deblank(map_s(11,:)))
next_map = 1;
j = 1;
while next_map
   colormap(deblank(map_s(j,1:10)))
   title(deblank(map_s(j,:)))
   j = j+1; if j>17, j = j-17;end
   next_map = input('Next (0 = stops) ? ');
   if isempty(next_map)
      next_map = 1;
   end
end
close gcf
