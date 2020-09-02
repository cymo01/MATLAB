function figs2ppt(filename)

% This function will export all open figures to a new MS
% Powerpoint presentation (an existing ppt with the same
% name/location will be overwritten).  Usage:
%
%   figs2ppt(filename)
%
% If filename is omitted, the function will open a filename 
% dialog box.  If filename is included it can either be a single 
% file name (which will be saved in the current directory), or 
% a name with a complete path.  The function will not correctly 
% handle relative file paths.
% 
% Written by J. Dunne, 3 July 2004
%

handles = sort(findobj('Type','figure'));

if length(handles)>0
    
    if nargin<1
        [pptname,pptpath] = uiputfile('*.ppt','Enter name for Powerpoint file');
        filename = [pptpath pptname];
    else
        pptname = filename;
        if isempty(find(filename=='\'))
            filename = [cd '\' filename];
        end
    end
    
    if ~isnumeric(pptname)
        ppt = actxserver ('Powerpoint.Application');
        invoke(ppt.Presentations,'Add');
        presentation = invoke(ppt.Presentations,'Item',1);
        height = presentation.PageSetup.SlideHeight;
        width = presentation.PageSetup.SlideWidth;
        slides = presentation.Slides;
        for i=1:length(handles)
            disp(['Generating slide # ' int2str(i)]);
            invoke(slides,'Add',i,12);
            slide = invoke(slides,'Item',i);
            shape = slide.Shapes;
            print(['-f' int2str(handles(i))],'-dpng','c:\figtemp.png');
            invoke(shape,'AddPicture','C:\figtemp.png',0,-1,10,10);
            pic = invoke(shape,'Item',1);
            pic.Height = single(double(height)-20);
        end
        invoke(presentation,'SaveAs',filename,1,-2);
        invoke(presentation,'Close'); invoke(ppt,'Quit'); delete(ppt);
        delete('C:\figtemp.png');
    end
else
    disp('There are no open figures to send to Powerpoint')
end