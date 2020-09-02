close all;
clear all;

Sea_State = 5;           % Sea State - 1 to 6
Sim_Length_sec = 1800;   % Simulation Duration (sec)
turn_rate = 1.8;         % deg/sec
min_leg_len = 400.0;     % minimum straight line segment length (sec)
max_leg_len = 600.0;     % maximum straight line segment length (sec)

vel_knots = random('unif', 7.0, 25.0)   % Nominal ship speed (knots)
vel_mps = vel_knots * 0.5144444;        % Nominal ship speed (meters/sec)

%dt = 0.01;
dt = 0.1
arr_size = Sim_Length_sec/dt;
init_head_deg = random('unif', 0.0, 360.0)
wave_direction = random('unif', 0.0, 360.0)
deg2rad = pi/180.0;
cw = cos(wave_direction*deg2rad);
sw = sin(wave_direction*deg2rad);
leg_length_sec = random('unif',min_leg_len, max_leg_len);
time_seg_start = 0.0;
InTurn = 0;

if((random('unif', 0.0, 1.0)) >= 0.5)
  turn_dir = 1.0;
else
  turn_dir = -1.0;
end

tc = 1.0/20.0;
% emag = 1.0/3.0 * Sea_State;
emag = 1.25;% 1.15;

samp = [0:(arr_size-1)];
time = samp * dt;
Markov_Noise = time;
Wave_Disturbance = time;
Nom_Head = time;
Head_Err = time;
Head_Dev = time;
Vel_N_mps = time;
Vel_E_mps = time;
Pos_N_m = time;
Pos_E_m = time;
Nom_Vel_N  = time;
Nom_Vel_E  = time;
GRandMean    = 0.0;
GRandStdDev  = 1.0;


% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %2011-Jul-01 Heading Wander
% % Create Random Heading Errors
% Markov_Noise(1) = emag * random('norm',GRandMean,GRandStdDev);
% emag         = emag * sqrt( 2.0 / (dt * tc) );
% for n = 2:arr_size
%   rand_dbl     = random('norm',GRandMean,GRandStdDev);
%   err          = tc * ((rand_dbl * emag) - Markov_Noise(n-1));
%   Markov_Noise(n) = Markov_Noise(n-1) + (err * dt);
% end
% 
% %Remove high frequency heading errors
% Head_dev(1) = Markov_Noise(1);
% % for n = 2:arr_size
% %   Head_dev(n) = Head_dev(n-1) + (15.0*(Markov_Noise(n)-Head_dev(n-1))*dt);
% % end
% 
% gain = 0.93; %0.95
% for n = 2:arr_size
%     Head_dev(n) = sqrt(1-gain^2)*Markov_Noise(n) + gain*Head_dev(n-1);
% end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 2011-Aug-12 Updated Heading wander the has low heading rate errors
mag_LF1 = 2
f_LF1 =  1/2000;
phase = random('unif', 0.0, 360.0)
Head_dev_LF1 = mag_LF1*cos(phase+time*f_LF1*2*pi);

mag_LF2 = 3
f_LF2 =  1/700;
Head_dev_LF2 = mag_LF2*sin(time*f_LF2*2*pi);

mag_MF = 8
f_MF =  1/300;
phase = random('unif', 0.0, 360.0)
Head_dev_MF = mag_MF*cos(phase +time*f_MF*2*pi);

Head_dev = Head_dev_LF1 +  Head_dev_LF2 + Head_dev_MF

%2011-08-15
%max_heading_rate = (mag_LF1*f_LF1 + mag_LF2*f_LF2 + mag_MF*f_MF + mag_HF*f_HF)*2*pi
max_heading_rate = (mag_LF1*f_LF1 + mag_LF2*f_LF2 + mag_MF*f_MF) *2*pi

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Nom_Head(1) = init_head_deg;
Des_Head = init_head_deg;

for n = 2:arr_size
  if(~InTurn)
    if((time(n)-time_seg_start) >= leg_length_sec)
      InTurn = 1;
      turn_dir = -turn_dir;
      Des_Head = Des_Head + random('unif',20.0, 60.0)*turn_dir;
    end
  end
  if(InTurn)
    Head_err = Des_Head - Nom_Head(n-1);
    if(Head_err > (turn_rate*dt))
      Head_err = turn_rate*dt;
    elseif(Head_err < (-turn_rate*dt))
      Head_err = -turn_rate*dt;
    else
      InTurn = 0;
      time_seg_start = time(n);
      leg_length_sec = random('unif',min_leg_len, max_leg_len);
    end;
    Nom_Head(n) = Nom_Head(n-1) + Head_err;    
  else
    Nom_Head(n) = Nom_Head(n-1);
  end
end

Heading_w_Wander = Nom_Head + Head_dev;

%Wave_Disturbance(1) = 0.0;

Nom_Vel_N = vel_mps * cos(Nom_Head*deg2rad);
Nom_Vel_E = vel_mps * sin(Nom_Head*deg2rad);

Vel_N_mps(1) = Nom_Vel_N(1);
Vel_E_mps(1) = Nom_Vel_E(1);

 Ideal_Pos_N_m(1) = 0.0;
 Ideal_Pos_E_m(1) = 0.0;

Wander_Vel_N = vel_mps * cos(Heading_w_Wander*deg2rad);
Wander_Vel_E = vel_mps * sin(Heading_w_Wander*deg2rad);

Wander_N_mps(1) = Wander_Vel_N(1);
Wander_E_mps(1) = Wander_Vel_E(1);

Wander_Pos_N_m(1) = 0.0;
Wander_Pos_E_m(1) = 0.0;

for n = 2:arr_size
  %Wave_Disturbance(n) = (Sea_State/4.5)*( 0.7*sin(0.52*time(n))-0.46*sin(0.63*time(n))+0.27*sin(0.69*time(n))-0.13*sin(0.78*time(n)));
   Ideal_Pos_N_m(n) = Ideal_Pos_N_m(n-1) + Nom_Vel_N(n)*dt;
   Ideal_Pos_E_m(n) = Ideal_Pos_E_m(n-1) + Nom_Vel_E(n)*dt;

  Wander_Pos_N_m(n) = Wander_Pos_N_m(n-1) + Wander_Vel_N(n)*dt;
  Wander_Pos_E_m(n) = Wander_Pos_E_m(n-1) + Wander_Vel_E(n)*dt;
end

%Ideal_Pos_N_m = Ideal_Pos_N_m + (Wave_Disturbance*cw);
%Ideal_Pos_E_m = Ideal_Pos_E_m + (Wave_Disturbance*sw);


% for n = 2:arr_size
%   Ideal_Vel_N_mps(n) = ( Ideal_Pos_N_m(n) - Ideal_Pos_N_m(n-1) )/dt; 
%   Ideal_Vel_E_mps(n) = ( Ideal_Pos_E_m(n) - Ideal_Pos_E_m(n-1) )/dt; 
%   
% end

figure;
plot(time, Nom_Head, time, Heading_w_Wander,'r');
title(' Heading (deg)');
xlabel('Time (sec)');
ylabel('Nominal Heading (deg)');
grid on;


% figure;
% plot(time, Wave_Disturbance);
% title('Wave Disturbance (m)');
% xlabel('Time (sec)');
% ylabel('Wave Disturbance (m)');
% grid on;
% 
figure;
plot(Ideal_Pos_N_m, Ideal_Pos_E_m,Wander_Pos_N_m,Wander_Pos_E_m, 'r' );
title('Position (m)');
xlabel('Position East (m)');
ylabel('Position North (m)');
grid on;
axis equal;
% 
% figure;
% plot(time, Ideal_Vel_N_mps, time, Wander_Vel_N,'r');
% title('North Velocity (mps)');
% xlabel('Time (sec)');
% ylabel('Velocity North (meters per sec)');
% grid on;
% 
% figure;
% plot(time, Ideal_Vel_E_mps, time, Wander_Vel_E,'r');
% title('East Velocity (mps)');
% xlabel('Time (sec)');
% ylabel('Velocity East (meters per sec)');
% grid on;
