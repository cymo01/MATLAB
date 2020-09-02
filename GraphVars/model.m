function [ret,x0,str,ts,xts]=model(t,x,u,flag);
%MODEL	is the M-file description of the SIMULINK system named MODEL.
%	The block-diagram can be displayed by typing: MODEL.
%
%	SYS=MODEL(T,X,U,FLAG) returns depending on FLAG certain
%	system values given time point, T, current state vector, X,
%	and input vector, U.
%	FLAG is used to indicate the type of output to be returned in SYS.
%
%	Setting FLAG=1 causes MODEL to return state derivatives, FLAG=2
%	discrete states, FLAG=3 system outputs and FLAG=4 next sample
%	time. For more information and other options see SFUNC.
%
%	Calling MODEL with a FLAG of zero:
%	[SIZES]=MODEL([],[],[],0),  returns a vector, SIZES, which
%	contains the sizes of the state vector and other parameters.
%		SIZES(1) number of states
%		SIZES(2) number of discrete states
%		SIZES(3) number of outputs
%		SIZES(4) number of inputs
%		SIZES(5) number of roots (currently unsupported)
%		SIZES(6) direct feedthrough flag
%		SIZES(7) number of sample times
%
%	For the definition of other parameters in SIZES, see SFUNC.
%	See also, TRIM, LINMOD, LINSIM, EULER, RK23, RK45, ADAMS, GEAR.

% Note: This M-file is only used for saving graphical information;
%       after the model is loaded into memory an internal model
%       representation is used.

% the system will take on the name of this mfile:
sys = mfilename;
new_system(sys)
simver(1.3)
if (0 == (nargin + nargout))
     set_param(sys,'Location',[457,249,957,549])
     open_system(sys)
end;
set_param(sys,'algorithm',     'RK-45')
set_param(sys,'Start time',    '0.0')
set_param(sys,'Stop time',     '999999')
set_param(sys,'Min step size', '0.0001')
set_param(sys,'Max step size', '.01')
set_param(sys,'Relative error','1e-3')
set_param(sys,'Return vars',   '')

add_block('built-in/Signal Generator',[sys,'/',['Signal',13,'Generator']])
set_param([sys,'/',['Signal',13,'Generator']],...
		'Peak','1.000000',...
		'Peak Range','5.000000',...
		'Freq','6.000000',...
		'Freq Range','5.000000',...
		'Wave','Sin',...
		'Units','Rads',...
		'position',[30,48,75,82])

add_block('built-in/Scope',[sys,'/','Scope'])
set_param([sys,'/','Scope'],...
		'Vgain','3.000000',...
		'Hgain','10.000000',...
		'Vmax','6.000000',...
		'Hmax','20.000000',...
		'Window',[3,372,334,686])
open_system([sys,'/','Scope'])
set_param([sys,'/','Scope'],...
		'position',[260,50,290,80])
add_line(sys,[80,65;255,65])

drawnow

% Return any arguments.
if (nargin | nargout)
	% Must use feval here to access system in memory
	if (nargin > 3)
		if (flag == 0)
			eval(['[ret,x0,str,ts,xts]=',sys,'(t,x,u,flag);'])
		else
			eval(['ret =', sys,'(t,x,u,flag);'])
		end
	else
		[ret,x0,str,ts,xts] = feval(sys);
	end
else
	drawnow % Flash up the model and execute load callback
end
