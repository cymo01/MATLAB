function doalign(varargin)
%DOALIGN Align Simulink or Stateflow objects
%   DOALIGN(H,Aligntype) aligns selected blocks in the current
%   system of the Simulink diagram with handle H according to
%   the Aligntype:
%       'Left'   = Align left edges
%       'Center' = Align centers (X)
%       'Right'  = Align right edges
%       'Top'    = Align top edges
%       'Middle' = Align middles (Y)
%       'Bottom' = Align bottom edges
%       'VDistAdj' = Vertical distribution spaced between adjacent edges
%       'VDistTop' = Vertical distribution spaced from top to top
%       'VDistMid' = Vertical distribution spaced between middles
%       'VDistBot' = Vertical distribution spaced from bottom to bottom
%       'HDistAdj' = Horizontal distribution spaced between adjacent edges
%       'HDistLeft' = Horizontal distribution spaced from left edges
%       'HDistCent' = Horizontal distribution spaced at centers
%       'HDistRight' = Horizontal distribution spaced at right edges
%       'Smart' = Align and Distribute into closest grid

%   K. Gondoly 5/27/03
%   Copyright 1991-2002 The MathWorks
%   $  $  $  $


vals = varargin{2};
if length(vals)~=4
    error('Bad alignment input');
end
vop = vals(1);
vspace = vals(2);
hop = vals(3);
hspace = vals(4);

% Otherwise, find all selected blocks in the current system
% and get their current positions
H = varargin{1};
blocks = find_system(H,'SearchDepth',1,'Selected','on');

% Even with a SearchDepth of 1, if searching in a subsystem and the
% subsystem block is selected in the parent level, it will end up 
% in the list. Make sure to parse it out!
Hname = getfullname(H);
nameMatch = strcmp(blocks,Hname);
blocks = blocks(~nameMatch);

pos = get_param(blocks,'Position');
pos = cat(1,pos{:}); % Pass a matrix of positions, one row per block

% Quick return if no or only one block is selected
if length(blocks)<=1,
    return
end

% Update position values based on selected vertical alignment
switch vop
    case 0
        %no-op
    case 4
        pos = topAlign(pos);
    case 2
        pos = middleAlign(pos);
    case 5
        pos = bottomAlign(pos);
    case 9
        pos = vMidDist(pos,vspace);
    otherwise
        error('bad vertical alignment type');
end

% Update position values based on selected horizontal alignment

switch hop
    case 0
        %noop
    case 1
        pos = leftAlign(pos);
    case 2
        pos = centerAlign(pos);
    case 3
        pos = rightAlign(pos);
    case 9
        pos = hCentDist(pos,hspace);
    otherwise
        error('bad horizontal alignment type');
end

% Set the new block positions. Unfortunately, not vectorized.
% Change to a call into C to get Undo/Redo
for ct = 1:length(blocks)
    set_param(blocks{ct},'Position',pos(ct,:));
end

%---------------------- Internal functions -------------------------
%%%%% Top Alignment %%%%%
function pos = topAlign(pos);
indBlocks = 1:size(pos,1);
[minPos,indMin] = min(pos(:,2));
indBlocks(indMin)=[];
pos(indBlocks,4) = pos(indBlocks,4)-(pos(indBlocks,2)-minPos);
pos(:,2) = minPos;

%%%%% Middle (vertically) Alignment %%%%%
function pos = middleAlign(pos);
% Align with the block whose middle is furthest down
middles = round(pos(:,2) + (pos(:,4)- pos(:,2))/2);
[ymid,indMax] = max(middles);
indBlocks = 1:size(pos,1);
indBlocks(indMax)=[];
for ct=1:length(indBlocks),
    numRow = indBlocks(ct);
    deltaY = pos(numRow,4)-pos(numRow,2);
    pos(numRow,2) = ymid - round(deltaY/2);
    pos(numRow,4) = ymid + round(deltaY/2);
end

%%%%% Bottom Alignment %%%%%
function pos = bottomAlign(pos);
indBlocks = 1:size(pos,1);
[maxPos,indMax] = max(pos(:,4));
indBlocks(indMax)=[];
pos(indBlocks,2) = maxPos-(pos(indBlocks,4)-pos(indBlocks,2));
pos(:,4) = maxPos;

%%%%% Vertical Middle Distribution %%%%%
function pos = vMidDist(pos,vspace);
if vspace<0,
    [minPos,indMin] = min(pos(:,4));
    [maxPos,indMax] = max(pos(:,2));
    y1 = pos(indMin,2) + round((pos(indMin,4)-pos(indMin,2))/2);
    y2 = pos(indMax,2) + round((pos(indMax,4)-pos(indMax,2))/2);
    vspace = round((y2-y1)/(size(pos,1)-1));
end

% Sort blocks vertically, so their order does not get messed up.
[sortedPos,indSort] = sortrows(pos,2);

indBlocks = 2:size(sortedPos,1);
height = sortedPos(1,4)-sortedPos(1,2);
minPos = sortedPos(1,2) + round(height/2);

for ct = indBlocks
    height= sortedPos(ct,4)-sortedPos(ct,2);
    minPos = minPos + vspace;
    sortedPos(ct,2) = minPos - round(height/2);
    sortedPos(ct,4) = minPos + round(height/2);
end % for ct

% Resort the positions into the original order.
pos(indSort,:) = sortedPos;

%%%%% Left Alignment %%%%%
function pos = leftAlign(pos);
indBlocks = 1:size(pos,1);
[minPos,indMin] = min(pos(:,1));
indBlocks(indMin)=[];
pos(indBlocks,3) = pos(indBlocks,3)-(pos(indBlocks,1)-minPos);
pos(:,1) = minPos;

%%%%% Center (Horizontal) Alignment %%%%%
function pos = centerAlign(pos);
% Align with the block whose middle is furthest down
centers = round(pos(:,1) + (pos(:,3)- pos(:,1))/2);
[xmid,indMax] = max(centers);
indBlocks = 1:size(pos,1);
indBlocks(indMax)=[];
for ct=1:length(indBlocks),
    numRow = indBlocks(ct);
    deltaX = pos(numRow,3)-pos(numRow,1);
    pos(numRow,1) = xmid - round(deltaX/2);
    pos(numRow,3) = xmid + round(deltaX/2);
end

%%%%% Right Alignment %%%%%
function pos = rightAlign(pos);
indBlocks = 1:size(pos,1);
[maxPos,indMax] = max(pos(:,3));
indBlocks(indMax)=[];
pos(indBlocks,1) = maxPos-(pos(indBlocks,3)-pos(indBlocks,1));
pos(:,3) = maxPos;

%%%%% Horizontal Center Distribution %%%%%
function pos = hCentDist(pos,hspace);
if hspace<0,
    [minPos,indMin] = min(pos(:,3));
    [maxPos,indMax] = max(pos(:,1));
    x1 = pos(indMin,1) + round((pos(indMin,3)-pos(indMin,1))/2);
    x2 = pos(indMax,1) + round((pos(indMax,3)-pos(indMax,1))/2);
    hspace = round((x2-x1)/(size(pos,1)-1));
end

% Sort blocks vertically, so their order does not get messed up.
[sortedPos,indSort] = sortrows(pos,1);

indBlocks = 2:size(sortedPos,1);
width = sortedPos(1,3)-sortedPos(1,1);
minPos = sortedPos(1,1) + round(width/2);

for ct = indBlocks
    width = sortedPos(ct,3)-sortedPos(ct,1);
    minPos = minPos + hspace;
    sortedPos(ct,1) = minPos - round(width/2);
    sortedPos(ct,3) = minPos + round(width/2);
end % for ct

% Resort the positions into the original order.
pos(indSort,:) = sortedPos;
