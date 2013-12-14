% =================================================================
% 
%  Main.m
%  Closed-loop position control for differential-drive robots.
% 
%  The calling syntax is:
%       Main
%
%  Reference:
%  Introduction to: Autonomous Mobile Robots, Chapter 3.
% 
%  This is an M-file for MATLAB.  
%  Tested in: Matlab 7.1.0
%  Date: 12.04.07
%
% =================================================================*/

clc; % clear console

path(path, './scans/');
path(path, './odometry/');

load('est_odo.mat');


%===================================%
%   PARAMETERS TO CHANGE            %
%===================================%

% NUMBER OF SCANS:
N = 360;

% TIME BETWEEN TWO SNAPSHOTS:
T_b_S = 0.5;  %[s]

% FREQUENCY OF ODOMETRY UPDATE:
F_O_U = 5;  %[Hz]

% NAME OF THE LOG FILE:
Log_name = 'log.txt';

%===================================%

% Open the log file for writing the data
FILE = fopen(Log_name, 'w')

tic;
for i=1:61
    % Schat hier dx en dtheta
    dx = est_odo(i, 1);
    dtheta = deg2rad(est_odo(i, 2));
    SaveEncoderData(FILE, toc, dx, dtheta, N);

    disp(sprintf('Taking laser data %d', (i + 10)));
    laser_scans = GetLaserScans(N, i+10);
    SaveLaserData(FILE, toc, laser_scans); 
    
    pause(T_b_S);
end

fclose(FILE);

display('Execution Complete!');
