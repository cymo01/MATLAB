function varargout = slalign(varargin)
% SLALIGN Opens an alignment tool for use with Simulink models
%      SLALIGN, by itself, creates a new Simulink Alignment Tool if one is
%      not yet opened, or brings an existing Alignment Tool to the front
%
%      Once open, the Alignment Tool can be used with any Simulink model.
%      By default, it will function on the Simulink model returned by GCS.
%
%      NOTE: This tool is being provided as an add-on to Simulink and is
%      not part of the shipping product. As such, certain limitations
%      exists, as follows:
%
%      1) Changes made using the Alignment Tool are not guarenteed to be
%      placed on the Undo stack.
%
%      2) Stateflow is not supported for R13. For R14, States and Transitions
%      can be aligned, but only if the Stateflow chart's ID is explicitly
%      passed as an input argmument to SLALIGN. 

% SLALIGN M-file for slalign.fig
%      SLALIGN, by itself, creates a new SLALIGN or raises the existing
%      singleton*.
%
%      H = SLALIGN returns the handle to a new SLALIGN or the handle to
%      the existing singleton*.
%
%      SLALIGN('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SLALIGN.M with the given input arguments.
%
%      SLALIGN('Property','Value',...) creates a new SLALIGN or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before slalign_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to slalign_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help slalign

% Last Modified by GUIDE v2.5 04-Sep-2003 11:36:41

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @slalign_OpeningFcn, ...
                   'gui_OutputFcn',  @slalign_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin & isstr(varargin{1})
    % Check if a Simulink diagram or Stateflow chart was passed in
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before slalign is made visible.
function slalign_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to slalign (see VARARGIN)

% Choose default command line output for slalign
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes slalign wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = slalign_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in OKbutton.
function OKbutton_Callback(hObject, eventdata, handles)
% hObject    handle to OKbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Preprocess GUI set-up: Find out what kind of alignment is being done
[vaop,vdop,vspace,haop,hdop,hspace,spick,cpick,sapply,capply] = getValues(handles);
H = gcs;
open_system(H); % Bring the model to the front

% Do properties, alignment, then distribution.
doProperties(H,handles,spick,cpick,sapply,capply);

if vaop | haop
    doAlign(H,[vaop,vspace,haop,hspace]);
end

if vdop | hdop
    doAlign(H,[vdop,vspace,hdop,hspace]);
end

close(get(hObject,'Parent'))

% --- Executes on button press in ApplyButton.
function ApplyButton_Callback(hObject, eventdata, handles)
% hObject    handle to ApplyButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Preprocess GUI set-up: Find out what kind of alignment is being done
[vaop,vdop,vspace,haop,hdop,hspace,spick,cpick,sapply,capply] = getValues(handles);
H = gcs;
open_system(H); % Bring the model to the front

% Do properties, alignment, then distribution.
doProperties(H,handles,spick,cpick,sapply,capply);

if vaop | haop
    doAlign(H,[vaop,vspace,haop,hspace]);
end

if vdop | hdop
    doAlign(H,[vdop,vspace,hdop,hspace]);
end

% --- Executes on button press in CancelButton.
function CancelButton_Callback(hObject, eventdata, handles)
% hObject    handle to CancelButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

close(get(hObject,'Parent'))

% --- Executes on button press in horizontal alignment.
function HorizontalAlign_Callback(hObject, eventdata, handles)
% hObject    handle to Horizontal Alignment button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

val = get(hObject,'Value');
if val, % Need to deselect other horizontal alignment button
    han = [handles.HorizontalOff,handles.LeftAlign,handles.CenterAlign,handles.RightAlign];
    set(han,'Value',0);
end
set(hObject,'Value',1)

% --- Executes on button press in vertical alignment.
function VerticalAlign_Callback(hObject, eventdata, handles)
% hObject    handle to Vertical Alignment button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

val = get(hObject,'Value');
if val, % Need to deselect other vertical alignment button
    han = [handles.VerticalOff,handles.TopAlign,handles.MiddleAlign,handles.BottomAlign];
    set(han,'Value',0);
end
set(hObject,'Value',1)

% --- Executes on button press in color properties.
function ColorProperties_Callback(hObject, eventdata, handles)
% hObject    handle to color properties button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

val = get(hObject,'Value');
if val, % Need to deselect other color alignment button
    han = [handles.PickUpColor,handles.ApplyColor];
    set(han,'Value',0);
    set(hObject,'Value',1);
end

% --- Executes on button press in size properties.
function SizeProperties_Callback(hObject, eventdata, handles)
% hObject    handle to size properties button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

val = get(hObject,'Value');
if val, % Need to deselect other siez button
    han = [handles.PickUpSize,handles.ApplySize];
    set(han,'Value',0);
    set(hObject,'Value',1);
end

% --- Executes on button press in HorizontalSpacing.
function HorizontalSpacing_Callback(hObject, eventdata, handles)
% hObject    handle to Horizontal Spacing checkbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Disable associated checkbox
if get(hObject,'Value')
    set(handles.hSpacingValue,'Enable','on','BackgroundColor',[1 1 1])
else
    set(handles.hSpacingValue,'Enable','off','BackgroundColor',[.8 .8 .8])
end

% --- Executes on button press in VerticalSpacing.
function VerticalSpacing_Callback(hObject, eventdata, handles)
% hObject    handle to VerticalSpacing checkbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Disable associated checkbox

if get(hObject,'Value')
    set(handles.vSpacingValue,'Enable','on','BackgroundColor',[1 1 1])
else
    set(handles.vSpacingValue,'Enable','off','BackgroundColor',[.8 .8 .8])
end

%-------------Pick-up/Apply Propreties
function doProperties(H,handles,spick,cpick,sapply,capply);

H = get_param(H,'Handle');
block = find_system(H,'SearchDepth',1,'Selected','on');
if (spick | cpick) & (length(block)~=1)
    errordlg('Can only pick up the properties of a single object. Please, select only one object in the current diagram.')
    return
end

propStr = get(handles.PropertyValues,'String');

ud = get(handles.PropertyValues,'UserData');

if spick,
    size = get_param(block,'Position');
    width = size(3)-size(1);
    height = size(4)-size(2);
    ud.height = height;
    ud.width = width;
end

if cpick,
    BC = get_param(block,'BackgroundColor');
    FC = get_param(block,'ForegroundColor');
    ud.backgroundColor = BC;
    ud.foregroundColor = FC;
end

if spick | cpick
    if ~isempty(ud.width)
        propStr1 = strvcat(['Width = ',num2str(ud.width)],['Height = ',num2str(ud.height)]);
    else
        propStr1='';
    end
    if ~isempty(ud.backgroundColor)
        propStr2 = strvcat(['Background = ',ud.backgroundColor],['Foreground = ',ud.foregroundColor]);
    else
        propStr2='';
    end
    propStr = strvcat(propStr1,propStr2);
end

set(handles.PropertyValues,'UserData',ud,'String',propStr)

if sapply,
    % Expand/contract size from the center of the block, to try to maintain
    % straight lines.
    if isempty(ud.width),
        errordlg('Please pick-up size properties before attempting to apply size to new objects.')
        return
    end
    for ct = 1:length(block)
        pos = get_param(block(ct),'Position');
        xmid = pos(1) + ((pos(3)-pos(1))/2);
        ymid = pos(2) + ((pos(4)-pos(2))/2);
        pos(1) = floor(xmid - ud.width/2);
        pos(3) = floor(xmid + ud.width/2);
        pos(2) = floor(ymid - ud.height/2);
        pos(4) = floor(ymid + ud.height/2);
        set_param(block(ct),'Position',pos)
   end
end

if capply
    if isempty(ud.foregroundColor),
        errordlg('Please pick-up color properties before attempting to apply colors to new objects.')
        return
    end
   for ct = 1:length(block)
       set_param(block(ct),'ForegroundColor',ud.foregroundColor,'BackgroundColor',ud.backgroundColor)
   end
    
end

%------------ Find values such that they match numbers used in GUIDE Align tool
function [vaop,vdop,vspace,haop,hdop,hspace,spick,cpick,sapply,capply] = getValues(handles);

cpick = get(handles.PickUpColor,'Value');
spick = get(handles.PickUpSize,'Value');
capply = get(handles.ApplyColor,'Value');
sapply = get(handles.ApplySize,'Value');

values = [get(handles.VerticalOff,'Value');
    0;get(handles.MiddleAlign,'Value');
    0;get(handles.TopAlign,'Value');
    get(handles.BottomAlign,'Value')];
vaop = find(values)-1;

haop = find([get(handles.HorizontalOff,'Value');
    get(handles.LeftAlign,'Value');
    get(handles.CenterAlign,'Value');
    get(handles.RightAlign,'Value')])-1;

hd = get(handles.HorizontalDistribute,'Value');
hspace = -1; hdop = 0;
if hd,
    hs = get(handles.HorizontalSpacing,'Value');
    hdop = 9;
    if hs,
        hspace = str2num(get(handles.hSpacingValue,'String'));
        % Crude error checking
        if isempty(hspace) | length(hspace)>1,
            errordlg('Invalue number for the Horizontal Spacing. Please enter a valid scalar.')
            return
        end
    end
end

vd = get(handles.VerticalDistribute,'Value');
vspace = -1;
vdop = 0;
if vd,
    vs = get(handles.VerticalSpacing,'Value');
    vdop = 9;
    if vs,
        vspace = str2num(get(handles.vSpacingValue,'String'));
        if isempty(vspace) | length(vspace)>1,
            errordlg('Invalue number for the Vertical Spacing. Please enter a valid scalar.')
            return
        end
    end
end


% --- Executes on button press in AlignButton.
function AlignButton_Callback(hObject, eventdata, handles)
% hObject    handle to AlignButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Preprocess GUI set-up: Find out what kind of alignment is being done
[vaop,vdop,vspace,haop,hdop,hspace,spick,cpick,sapply,capply] = getValues(handles);
H = gcs;
open_system(H); % Bring the model to the front

if vaop | haop
    doAlign(H,[vaop,vspace,haop,hspace]);
end

% --- Executes on button press in DistributeButton.
function DistributeButton_Callback(hObject, eventdata, handles)
% hObject    handle to DistributeButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Preprocess GUI set-up: Find out what kind of alignment is being done
[vaop,vdop,vspace,haop,hdop,hspace,spick,cpick,sapply,capply] = getValues(handles);
H = gcs;
open_system(H); % Bring the model to the front

if vdop | hdop
    doAlign(H,[vdop,vspace,hdop,hspace]);
end

% --- Executes on button press in PropertiesButton.
function PropertiesButton_Callback(hObject, eventdata, handles)
% hObject    handle to PropertiesButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Preprocess GUI set-up: Find out what kind of alignment is being done
[vaop,vdop,vspace,haop,hdop,hspace,spick,cpick,sapply,capply] = getValues(handles);
H = gcs;
open_system(H); % Bring the model to the front
doProperties(H,handles,spick,cpick,sapply,capply);
