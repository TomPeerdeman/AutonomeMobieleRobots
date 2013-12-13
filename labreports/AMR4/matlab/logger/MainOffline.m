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
figure(2)
for i=1:40
    rem_time = T_b_S;
    
    %% DURING X SECONDS, THE ROBOT EVOLVES AND SAVE THE ODOMETRY MEASURES
    while(rem_time>0 & ~Stop_Robot)
        t_time = toc;
        robotData = GetRobotData(); % retrieve data packet from NXT
        [dEncoder, encoder] = GetEncoder(robotData, encoder); % get wheel encoder values
        dS = dEncoder * robotConst(1); % calculate change in displacement from previous time step
        [dx, dtheta]=Odometry(dS, robotConst(2)); % gets the odometry in the robot-centered reference system
        
        % Schat hier dx en dtheta
        SaveEncoderData(FILE, toc, dx, dtheta, N);

        pause(1/F_O_U);
        rem_time = rem_time - (toc - t_time);
    end

    disp('Taking laser data');
    laser_scans = GetLaserScans(N, i+10);
    SaveLaserData(FILE, toc, laser_scans); 
    
end

fclose(FILE);

display('Execution Complete!');
