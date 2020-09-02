function [varargout] = kyfun(h,arg);

% The function KYFUN adds keypress functionality to a figure.  Its basic
% usage is:
%
% KYFUN(h,arg)
%
% h is the figure handle of interest, and arg is an optional argument.  h
% can be a vector of figure handles.  When arg is not provided,
% functionality is toggled for each figure specified.  If no figure is
% specified, the current figure is affected.  If h contains 0, all figures 
% are selected.  The optional argument can take on the following values:
%
%     '?' - function provides feedback specifying whether functionality is
%           in place for that figure (displayed if no output is requested,
%           or returned as a vector otherwise).  1 means enabled, 0 means
%           not.
%     's' - for 'set', forces all figures to have functionality enabled
%     'r' - for 'remove', removes functionality
%     't' - for 'toggle', toggles functionality (this is the default)
%
% Once functionality has been enabled, the following keypresses will be
% available for the figure (listed in no particular order):
%
% 'g' - Toggle the grid
% 'G' - Apply the geoaspect function to the figure (i.e. set the aspect to
%       one appropriate for a geographic image - requires geoaspect)
% 'n' - Release axis constraints (i.e. axis normal)
% 'v' - Add a vertical colorbar
% 'V' - Remove a vertical colorbar
% 'h' - Add a horizontal colorbar
% 'H' - Remove a horizontal colorbar
% 'c' - Reset the color scale for the current viewing area
% 'C' - Reset the color scale for the full image
% 'u' - Pan up by 20% of the viewing area
% 'U' - Pan up by 4% of the viewing area
% 'd', 'D', 'l', 'L', 'r', 'R' - Same for down, left, right
% ';' - Zoom in by ~20%
% ':' - Zoom out by ~120%
% '[' - Zoom in the x-axis by ~20%
% '{' - Zooom out in the x-axis by ~120%
% ']' - Zoom in the y-axis by ~20%
% '}' - Zooom out in the y-axis by ~120%
% 'S' - Send/steal figure data into the base workspace For each graphic
%       object a structure is created with fields x, y, and data containing
%       the x-axis, the y-axis, and the color data, respectively.  Multiple
%       objects result in a structure array.
% 's' - Saves the figure (pretty much like hitting the little disk icon)
% 'p' - Export figure to a .png file
% 'P' - Send figure to the printer
% 'j' - Export figure to a .jpg file
% 'm' - Send figure to the clipboard as an enhanced metafile
% 'M' - send figure to the clipboard as a bitmap
% 'f' - Increase all font sizes by 1 point
% 'F' - Decrease all font sizes by 1 point
% 'w' - Increase all line widths by 0.5 points
% 'W' - Decrease all line widths by 0.5 points
% 'o' - Remove a legend
% 'Q' - Close the figure
% 'q' - Disabled keypress functionality
% 'k' - Remove axis labels
% 't' - Remove plot title
% 'x' - Reverse the x-axis
% 'X' - Toggle between linear and log scales for the x-axis
% 'y' - Reverse the y-axis
% 'Y' - Toggle between linear and log scales for the y-axis
% 'z' - Reverse the z-axis
% 'Z' - Toggle between linear and log scales for the z-axis
% 'i' - Invert the colormap
% 'a' - Turn off the axes
% 'A' - Turn on the axes
% '=' - Select the next object in the axes
% '+' - Select the previous object in the axes
% 'backspace' - Deselect all objects in the axes
% '1' - Increase red contribution (by 0.1) to the color of the
%       selected line/text or to the top of the color scale if
%       if nothing is selected
% '2' - Same for green
% '3' - Same for blue
% '4' - Increase red contribution (by 0.1) to the color at the
%       bottom of the color scale
% '5' - Same for green
% '6' - Same for blue
% '!@#$%^' - Same as 1-6 above, but with decreases
% '\' - Cycle colormap forward by one step
% '|' - Cycle colormap backward by one step
% '-' - Downsample colormap by a factor of ~2
% '_' - Upsample colormap by a factor of ~2
% ',' - Set colormap to jet with 64 color resolution
% '<' - Cycle colormap through: GRAY, HOT, COOL, BONE, COPPER, PINK, FLAG,
%       PRISM, and JET (maintains current resolution)
% '/' - Grab a single coordinate point and return it in the base workspace
%       as a row vector called figurepoint (cancel by hitting return)
% '?' - Same as '/', but collects two points (each row is a coordinate
%       point)
%
% Written by J.A. Dunne, 8-3-05
%

if nargin<1, h = gcf; end

if ischar(h)
    arg = h;
    h = gcf;
else
    if nargin<2
        arg = 't';
    else
        arg = lower(arg(1));
    end
end

if ~iscell(h)
    if sum(h==0)>0
        h = findobj('type','figure');
    end
    for i=1:length(h)
        if arg=='t'
            if length(get(h(i),'KeyPressFcn'))
                stg='';
            else
                stg='kyfun({1})';
            end
        else
            if arg == '?'
                stg = get(h(i),'KeyPressFcn');
                out(i) = strcmp(stg,'kyfun({1})');
            else
                if arg=='r'
                    stg='';
                else
                    stg='kyfun({1})';
                end
            end
        end
        set(h(i),'KeyPressFcn',stg);
    end
    if arg=='?'
        if nargout>0
            varargout{1} = out;
        else
            for i=1:length(h)
                st = {'Disabled' 'Enabled'};
                disp(['Figure ' num2str(h(i)) ': ' st{out(i)+1}]);
            end
        end
    end
else

    hf = gcf;
    switch get(gcf,'CurrentCharacter');
        case 'g'
            grid;
        case 'G'
            geoaspect;
        case 'v'
            colorbar('vert');
        case 'V'
            q = colorbar('vert');
            delete(q);
        case 'h'
            colorbar('horiz');
        case 'H'
            q = colorbar('horiz');
            delete(q);
        case 'u'
            lims = axis(gca);
            dy = lims(4)-lims(3);
            lims([3 4]) = lims([3 4]) + .2*dy;
            axis(lims);
        case 'U'
            lims = axis(gca);
            dy = lims(4)-lims(3);
            lims([3 4]) = lims([3 4]) + .04*dy;
            axis(lims);
        case 'd'
            lims = axis(gca);
            dy = lims(4)-lims(3);
            lims([3 4]) = lims([3 4]) - .2*dy;
            axis(lims);
        case 'D'
            lims = axis(gca);
            dy = lims(4)-lims(3);
            lims([3 4]) = lims([3 4]) - .04*dy;
            axis(lims);
        case 'l'
            lims = axis(gca);
            dx = lims(2)-lims(1);
            lims([1 2]) = lims([1 2]) - .2*dx;
            axis(lims);
        case 'L'
            lims = axis(gca);
            dx = lims(2)-lims(1);
            lims([1 2]) = lims([1 2]) - .04*dx;
            axis(lims);
        case 'r'
            lims = axis(gca);
            dx = lims(2)-lims(1);
            lims([1 2]) = lims([1 2]) + .2*dx;
            axis(lims);
        case 'R'
            lims = axis(gca);
            dx = lims(2)-lims(1);
            lims([1 2]) = lims([1 2]) + .04*dx;
            axis(lims);
        case ';'
            lims = axis(gca);
            dx = (lims(2)-lims(1))/10;
            dy = (lims(4)-lims(3))/10;
            axis([lims(1)+dx lims(2)-dx lims(3)+dy lims(4)-dy]);
        case ':'
            lims = axis(gca);
            dx = (lims(2)-lims(1))/8;
            dy = (lims(4)-lims(3))/8;
            axis([lims(1)-dx lims(2)+dx lims(3)-dy lims(4)+dy]);
        case '['
            lims = axis(gca);
            dx = (lims(2)-lims(1))/10;
            axis([lims(1)+dx lims(2)-dx lims(3) lims(4)]);
        case '{'
            lims = axis(gca);
            dx = (lims(2)-lims(1))/8;
            axis([lims(1)-dx lims(2)+dx lims(3) lims(4)]);
        case ']'
            lims = axis(gca);
            dy = (lims(4)-lims(3))/10;
            axis([lims(1) lims(2) lims(3)+dy lims(4)-dy]);
        case '}'
            lims = axis(gca);
            dy = (lims(4)-lims(3))/8;
            axis([lims(1) lims(2) lims(3)-dy lims(4)+dy]);
        case 'c'
            lims = axis(gca);
            hkids = get(gca,'children');
            for i=1:hkids
                if strcmp(get(hkids(i),'type'),'image')
                        % Found an image
                        cdata = get(hkids(i),'cdata');
                        xdata = get(hkids(i),'xdata');
                        if length(xdata)~=size(cdata,2)
                            xdata = [xdata(1):xdata(2)];
                        end
                        ydata = get(hkids(i),'ydata');
                        if length(ydata)~=size(cdata,1)
                            ydata = [ydata(1):ydata(2)];
                        end
%                         if lims(1)<xdata(1), lims(1)=xdata(1); end
%                         if lims(2)>xdata(2), lims(2)=xdata(end); end
%                         if lims(3)<ydata(1), lims(3)=ydata(1); end
%                         if lims(4)>ydata(2), lims(4)=ydata(end); end
                        xlims = interp1(xdata,1:size(cdata,2),lims([1 2]),'nearest','extrap');
                        ylims = interp1(ydata,1:size(cdata,1),lims([3 4]),'nearest','extrap');
                        newmat = cdata([ylims(1):ylims(2)],[xlims(1):xlims(2)]);
                        mn = min(min(newmat));
                        mx = max(max(newmat));
                        caxis([mn mx]);
                    break
                end
            end
        case 'C'
            hkids = get(gca,'children');
            for i=1:hkids
                if strcmp(get(hkids(i),'type'),'image')
                        % Found an image
                        cdata = get(hkids(i),'cdata');
                        mn = min(min(cdata));
                        mx = max(max(cdata));
                        caxis([mn mx]);
                    break
                end
            end
        case 'S'
            hkids = get(gca,'children');
            for i=1:length(hkids)
                obj(i).x = get(hkids(i),'xdata');
                obj(i).y = get(hkids(i),'ydata');
                obj(i).data = [];
                if strcmp(get(hkids(i),'type'),'image')
                    obj(i).data = get(hkids(i),'cdata');
                end
            end
            assignin('base','figuredata',obj);
            disp('Data taken from figure and stored in variable ''figuredata''.')
        case 'O'
            delete(legend);
        case 'Q'
            close(hf);
        case 'q'
            set(hf,'KeyPressFcn','');
        case 'k'
            delete(xlabel(''));
            delete(ylabel(''));
            delete(zlabel(''));
        case 't'
            delete(title(''));
        case 'a'
            axis off
        case 'A'
            axis on
        case 'x'
            val = get(gca,'xdir');
            if strcmp(lower(val),'normal')
                set(gca,'xdir','reverse');
            else
                set(gca,'xdir','normal');
            end
        case 'y'
            val = get(gca,'ydir');
            if strcmp(lower(val),'normal')
                set(gca,'ydir','reverse');
            else
                set(gca,'ydir','normal');
            end
        case 'z'
            val = get(gca,'zdir');
            if strcmp(lower(val),'normal')
                set(gca,'zdir','reverse');
            else
                set(gca,'zdir','normal');
            end
        case 'X'
            val = get(gca,'xscale');
            if strcmp(lower(val),'linear')
                set(gca,'xscale','log');
            else
                set(gca,'xscale','linear');
            end
        case 'Y'
            val = get(gca,'yscale');
            if strcmp(lower(val),'linear')
                set(gca,'yscale','log');
            else
                set(gca,'yscale','linear');
            end
        case 'Z'
            val = get(gca,'zscale');
            if strcmp(lower(val),'linear')
                set(gca,'zscale','log');
            else
                set(gca,'zscale','linear');
            end
        case 'i'
            colormap(flipud(colormap));
        case 'm'
            print -dmeta;
        case 'M'
            print -dbitmap;
        case 'P'
            printdlg(hf);
        case 's'
            [fname, path] = uiputfile({'*.fig' 'MATLAB Figure Files'}, 'Enter file name');
            if ischar(fname)
                [pathstr,name,ext,versn] = fileparts([path fname]);
                fn = [pathstr filesep name '.fig'];
                saveas(hf,fn);
            end
        case 'p'
            [fname, path] = uiputfile({'*.png' 'Portable Network Graphic Files'}, 'Enter file name');
            if ischar(fname)
                [pathstr,name,ext,versn] = fileparts([path fname]);
                fn = [pathstr filesep name '.png'];
                print(hf,'-dpng',fn);
            end
        case 'j'
            [fname, path] = uiputfile({'*.jpg' 'JPEG Files'}, 'Enter file name');
            if ischar(fname)
                [pathstr,name,ext,versn] = fileparts([path fname]);
                fn = [pathstr filesep name '.jpg'];
                print(hf,'-djpeg',fn);
            end
        case 'w'
            hkids = get(gca,'children');
            for i=1:length(hkids)
                if strcmp(lower(get(hkids(i),'type')),'line')
                    set(hkids(i),'linewidth',get(hkids(i),'linewidth')+0.5);
                end
            end
        case 'W'
            hkids = get(gca,'children');
            for i=1:length(hkids)
                if strcmp(lower(get(hkids(i),'type')),'line')
                    if get(hkids(i),'linewidth')>0.5
                        set(hkids(i),'linewidth',get(hkids(i),'linewidth')-0.5);
                    end
                end
            end
        case 'f'
            set(gca,'fontsize',get(gca,'fontsize')+1);
            set(get(gca,'xlabel'),'fontsize',get(get(gca,'xlabel'),'fontsize')+1);
            set(get(gca,'ylabel'),'fontsize',get(get(gca,'ylabel'),'fontsize')+1);
            set(get(gca,'zlabel'),'fontsize',get(get(gca,'zlabel'),'fontsize')+1);
            set(get(gca,'title'),'fontsize',get(get(gca,'title'),'fontsize')+1);
            hkids = get(gca,'children');
            for i=1:length(hkids)
                if strcmp(lower(get(hkids(i),'type')),'text')
                    set(hkids(i),'fontsize',get(hkids(i),'fontsize')+1);
                end
            end
        case 'F'
            x=get(gca,'fontsize');
            if x>1, set(gca,'fontsize',x-1); end
            x=get(get(gca,'xlabel'),'fontsize');
            if x>1, set(get(gca,'xlabel'),'fontsize',x-1); end
            x=get(get(gca,'ylabel'),'fontsize');
            if x>1, set(get(gca,'ylabel'),'fontsize',x-1); end
            x=get(get(gca,'zlabel'),'fontsize');
            if x>1, set(get(gca,'zlabel'),'fontsize',x-1); end
            x=get(get(gca,'title'),'fontsize');
            if x>1, set(get(gca,'title'),'fontsize',x-1); end
            hkids = get(gca,'children');
            for i=1:length(hkids)
                if strcmp(lower(get(hkids(i),'type')),'text')
                    x = get(hkids(i),'fontsize');
                    if x>1, set(hkids(i),'fontsize',x-1); end
                end
            end
        case 'n'
            axis normal;
        case '1'
            hkids = get(gca,'children');
            nonefound = 1;
            for i=1:length(hkids)
                if strcmp(get(hkids(i),'selected'),'on')
                    nonefound = 0;
                    switch get(hkids(i),'type')
                        case {'line','text'}
                            set(hkids(i),'color',min([1 1 1],get(hkids(i),'color')+[0.1 0 0]));
                    end
                end
            end
            if nonefound
                cm = colormap;
                cm(end,:) = min([1 1 1],cm(end,:)+[0.1 0 0]);
                colormap(cm);
            end
        case '2'
            hkids = get(gca,'children');
            nonefound = 1;
            for i=1:length(hkids)
                if strcmp(get(hkids(i),'selected'),'on')
                    nonefound = 0;
                    switch get(hkids(i),'type')
                        case {'line','text'}
                            set(hkids(i),'color',min([1 1 1],get(hkids(i),'color')+[0 0.1 0]));
                    end
                end
            end
            if nonefound
                cm = colormap;
                cm(end,:) = min([1 1 1],cm(end,:)+[0 0.1 0]);
                colormap(cm);
            end
        case '3'
            hkids = get(gca,'children');
            nonefound = 1;
            for i=1:length(hkids)
                if strcmp(get(hkids(i),'selected'),'on')
                    nonefound = 0;
                    switch get(hkids(i),'type')
                        case {'line','text'}
                            set(hkids(i),'color',min([1 1 1],get(hkids(i),'color')+[0 0 0.1]));
                    end
                end
            end
            if nonefound
                cm = colormap;
                cm(end,:) = min([1 1 1],cm(end,:)+[0 0 0.1]);
                colormap(cm);
            end
        case '!'
            hkids = get(gca,'children');
            nonefound = 1;
            for i=1:length(hkids)
                if strcmp(get(hkids(i),'selected'),'on')
                    nonefound = 0;
                    switch get(hkids(i),'type')
                        case {'line','text'}
                            set(hkids(i),'color',max([0 0 0],get(hkids(i),'color')-[0.1 0 0]));
                    end
                end
            end
            if nonefound
                cm = colormap;
                cm(end,:) = max([0 0 0],cm(end,:)-[0.1 0 0]);
                colormap(cm);
            end
        case '@'
            hkids = get(gca,'children');
            nonefound = 1;
            for i=1:length(hkids)
                if strcmp(get(hkids(i),'selected'),'on')
                    nonefound = 0;
                    switch get(hkids(i),'type')
                        case {'line','text'}
                            set(hkids(i),'color',max([0 0 0],get(hkids(i),'color')-[0 0.1 0]));
                    end
                end
            end
            if nonefound
                cm = colormap;
                cm(end,:) = max([0 0 0],cm(end,:)-[0 0.1 0]);
                colormap(cm);
            end
        case '#'
            hkids = get(gca,'children');
            nonefound = 1;
            for i=1:length(hkids)
                if strcmp(get(hkids(i),'selected'),'on')
                    nonefound = 0;
                    switch get(hkids(i),'type')
                        case {'line','text'}
                            set(hkids(i),'color',max([0 0 0],get(hkids(i),'color')-[0 0 0.1]));
                    end
                end
            end
            if nonefound
                cm = colormap;
                cm(end,:) = max([0 0 0],cm(end,:)-[0 0 0.1]);
                colormap(cm);
            end
       case '4'
            cm = colormap;
            cm(1,:) = min([1 1 1],cm(1,:)+[0.1 0 0]);
            colormap(cm);
       case '5'
            cm = colormap;
            cm(1,:) = min([1 1 1],cm(1,:)+[0 0.1 0]);
            colormap(cm);
       case '6'
            cm = colormap;
            cm(1,:) = min([1 1 1],cm(1,:)+[0 0 0.1]);
            colormap(cm);
       case '$'
            cm = colormap;
            cm(1,:) = max([0 0 0],cm(1,:)-[0.1 0 0]);
            colormap(cm);
       case '%'
            cm = colormap;
            cm(1,:) = max([0 0 0],cm(1,:)-[0 0.1 0]);
            colormap(cm);
       case '^'
            cm = colormap;
            cm(1,:) = max([0 0 0],cm(1,:)-[0 0 0.1]);
            colormap(cm);
       case '\'
            cm = colormap;
            if size(cm,1)>1
                colormap(cm([2:end 1],:));
            end
        case '|'
            cm = colormap;
            if size(cm,1)>1
                colormap(cm([end 1:end-1],:));
            end
        case '-'
            cm = colormap;
            colormap(cm(1:2:end,:));
        case '_'
            cm = colormap;
            colormap(interp2(1:3,1:size(cm,1),cm,1:3,[1:0.5:size(cm,1)]'));
        case ','
            colormap(jet(64));
        case '<'
            cm = colormap;
            maps = {'gray' 'hot' 'cool' 'bone' 'copper' 'pink' 'flag' 'prism' 'jet'};
            newmap = 'gray';
            for i=1:length(maps)-1
                if isequal(cm,eval([maps{i} '(' num2str(size(cm,1)) ')']))
                    newmap = maps{i+1};
                    break;
                end
            end
            colormap(eval([newmap '(' num2str(size(cm,1)) ')']));
        case '='
            hkids = get(gca,'children');
            hsel = 0;
            for i=1:length(hkids)
                if strcmp(get(hkids(i),'selected'),'on')
                    hsel = i;
                end
            end
            if hsel==length(hkids)
                hsel = 0;
            end
            hsel = hsel + 1;
            opts = {'off' 'on'};
            for i=1:length(hkids)
                set(hkids(i),'selected',opts{(hsel==i)+1});
            end
        case '+'
            hkids = get(gca,'children');
            hsel = length(hkids)+1;
            for i=1:length(hkids)
                if strcmp(get(hkids(i),'selected'),'on')
                    hsel = i;
                end
            end
            if hsel==1
                hsel = length(hkids)+1;
            end
            hsel = hsel - 1;
            opts = {'off' 'on'};
            for i=1:length(hkids)
                set(hkids(i),'selected',opts{(hsel==i)+1});
            end
        case char(8)
            hkids = get(gca,'children');
            for i=1:length(hkids)
                set(hkids(i),'selected','off');
            end
        case '/'
            [x,y] = ginput(1);
            if length(x)>0
                assignin('base','figurepoint',[x y]);
                disp(['Point from figure (' num2str(x) ',' num2str(y) ') stored in variable ''figurepoint''.'])
            end
        case '?'
            [x,y] = ginput(2);
            if length(x)>1
                assignin('base','figurepoint',[x(:) y(:)]);
                disp(['Points from figure stored in variable ''figurepoint''.'])
            end
                
%         otherwise
%             disp(num2str(double(get(gcf,'CurrentCharacter'))))

    end
end