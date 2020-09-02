function addTraceList(timeEvents, nameEvents, varargin)
%
% Function to add event names to a time-based plot
%
%  Data should be in a 1x1 structure as:
%    missileEvents.time=[10, 50, 100];  %an array of doubles
%    missileEvents.name={'Launch' ,'Midcourse', 'Terminal'}; %a cell array
%                                                              of character strings
%  Use:
%    addTraceList(missileEvents.time,missileEvents.name);
%
if (~isempty(varargin)),
    for i=1:length(timeEvents),
        addTrace(timeEvents(i), nameEvents(i), varargin)
    end
else
    for i=1:length(timeEvents),
        addTrace(timeEvents(i), nameEvents(i))
    end
end

function addTrace(xEvent, nameEvent, varargin)
if (~isempty(varargin)),
    linecolor=varargin{1};
else
    linecolor={'r'};
end

hold on;
v=axis;
plot([xEvent, xEvent], v(3:4), 'LineStyle','--','Color',linecolor{1},'LineWidth',1.1);
axis(v);
text(xEvent, v(4), ['  ' nameEvent],'Color',linecolor{1});
hold off
