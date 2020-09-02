function keep(varargin);
%KEEP keeps the base workspace variables of your choice and clear the rest.
%	Its usage is just like "clear".
%
%	Xiaoning (David) Yang	xyang@lanl.gov 1998
 
%	See what are in base workspace
wh = evalin('base','who');

%	Construct a string containing base workspace variables delimited by ":"
variable = [];
for i = 1:length(wh)
variable = [variable,':',wh{i}];
end
variable = [variable,':'];

%	Extract desired variables from string
for i = 1:length(varargin)
	I = findstr(variable,[':',varargin{i},':']);
	if I == 1
		variable = variable(I+length(varargin{i})+1:length(variable));
	elseif I+length(varargin{i})+1 == length(variable)
		variable = variable(1:I);
	else
		variable = [variable(1:I),variable(I+length(varargin{i})+2:length(variable))];
	end
end

%	Convert string back to cell
I = findstr(variable,':');
for i = 1:length(I)-1
	if i ~= length(I)-1
		del(i) = {[variable(I(i)+1:I(i+1)-1),' ']};
	else
		del(i) = {variable(I(i)+1:length(variable)-1)};
	end
end

%	Delete the rest
evalin('base',['clear ',del{:}])
