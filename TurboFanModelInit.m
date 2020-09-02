% NOTE: The values contained in this file are UNCLASSIFIED -- supplied by Justin Edmondson, ONI for an UNCLASS propulsion system

% Flight Conditions
EngineState.Flight_Condition(1)=0.9;
EngineState.Flight_Condition(2)=1000.0;
EngineState.Flight_Condition(3)=0.5725;

% Engine Parameters
EngineState.Engine_Parameters(1) = 3.758;   % Compressor PTr
EngineState.Engine_Parameters(2) = 0.9281;  % Compressor poly-eff (ideal = 1)
EngineState.Engine_Parameters(3) = 0.9787;  % Burner eff. (ideal = 1)
EngineState.Engine_Parameters(4) = 0.9307;  % Burner PTr (ideal = 1)
EngineState.Engine_Parameters(5) = 0.9504;  % Mechanical eff. (ideal = 1)
EngineState.Engine_Parameters(6) = 0.8170;  % Turbine poly-eff. (ideal = 1)
EngineState.Engine_Parameters(7) = 0.2996;  % Compressor bleed
EngineState.Engine_Parameters(8) = 1.0;     % Bypass fan PTr
EngineState.Engine_Parameters(9) = 0.0;     % Bypass ratio
EngineState.Engine_Parameters(10) = 0.8460; % Bypass fan poly-eff (ideal = 1)

% System Data
SystemData.System_Parameters(1) = 4.280e07;  % Fuel lower-heating value (J/kg)
SystemData.System_Parameters(2) = 1.33;      % Exhaust spec heat ratio
SystemData.System_Parameters(3) = 1.540e03;  % Maximum turbine blade temp (K)
SystemData.System_Parameters(4) = 1;         % Inlet/diffuser PTr (ideal = 1)
SystemData.System_Parameters(5) = 1;         % Core nozzle PTr (ideal = 1)
SystemData.System_Parameters(6) = 2.76e-02;  % Core nozzle X-Sectional Area (m^2)
SystemData.System_Parameters(7) = 1.540e03;         % Bypass nozzle PTr (ideal = 1)
SystemData.System_Parameters(8) = 1.0;       % Bypass nozzle X-Sectional Area (mm^2)
SystemData.System_Parameters(9) = 1.0;         % Core nozzle PTr (ideal = 1)
SystemData.System_Parameters(10) = 2.76e-02;  % Core nozzle X-Sectional Area (m^2)
SystemData.System_Parameters(11) = 1;         % Bypass nozzle PTr (ideal = 1)
SystemData.System_Parameters(12) = 0.0;       % Bypass nozzle X-Sectional Area (mm^2)

timeflag = 1;
% Atmospheric Conditions

0.0; % Stage Time To Start Burn (s)