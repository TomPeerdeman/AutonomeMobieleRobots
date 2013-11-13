% =================================================================
% 
%  ContStep.m
%  Closed-loop position control for differential-drive robots.
% 
%  The calling syntax is:
% 
% 		[PhiPrime, rho, alpha, pose, EndCond] = ContStep(dS, S, goalPose, pose, startPose, robotConst)
% 
%       outputs:
%           PhiPrime: [phiprime_r,phiprime_l] = angular velocity of the right/left wheel
%           [rad/s]
%           rho[] = displacement of the robot from the goal position
%           alpha[] = angle between the trajectory vector with respect to the robot's frame
%           pose: [x,y,theta] = present pose of the robot (i.e. position-x, position-y, orientation)
%           EndCond = end condition for the controller
%
%       inputs:
%           dS: [dSr,dSl] = displacement of the encoder from the previous time step
%           S = accumulated displacement of of the encoder
%           goalPose: [x,y,theta,error_dist,error_angle]
%           = goal pose in meters and degrees with respect to the inertial frame and admitted error
%           pose: [x,y,theta] = position of the robota at last step (i.e. position-x, position-y, orientation) with respect to the inertial frame
%           startPose: [x,y,theta] = initial pose of the robot (i.e. position-x, position-y, orientation) with respect to the inertial frame
%           robotConst: [wheel radius, 1/2 wheelbase] = various constants pertaining to the robot (meters)
%           Time: current time
% 
%  Reference:
%  Introduction to: Autonomous Mobile Robots, Chapter 3.
% 
%  This is an M-file for MATLAB.  
%  Tested in: Matlab 7.6.0
%  Date: 26.02.09, Tâche F.
% 
% =================================================================*/

function [PhiPrime, rho, alpha, beta, pose, EndCond] = ContStepSolution(dS, S, goalPose, pose, startPose, robotConst, Time)

    global Krho;
    global Kalpha;
    global Kbeta;
    
    r = 1;
    l = 2;
    Sl = S(l); % accumulated encoder values for the left wheel [m]
    Sr = S(r); % accumulated encoder values for the right wheel [m]
    dSl = dS(l); % change in the encoder value for the left wheel since the last time step [m]
    dSr = dS(r); % change in the encoder value for the right wheel since the last time step [m]
    wheelRadius = robotConst(1); % [m]
    halfWheelbase = robotConst(2); % [m]
    xg = goalPose(1); % [m]
    yg = goalPose(2); % [m]
    thetag = goalPose(3); % [rad]
    dist_error = goalPose(4); % [m]
    angle_error = goalPose(5); % [rad]
    x = pose(1); % [m]
    y = pose(2); % [m]
    theta = pose(3); % [rad]
    % We don't need the start position!!!
    
    %-----   Put your code here   ---------------------------------------------
    
%     PhiPrime = [0,0];
%     rho = 0;
%     alpha = 0;
%     pose = [0,0,0];
%     EndCond = 0;
%     
%     if (Time > 2.5)
%         EndCond = 1;
%     end

    OpenLoop = 0;
    BackwardOK = 1;

    if OpenLoop

    %     EndCond = 0;
    %     if (Time < 5)
    %         PhiPrime(l) = 0;
    %         PhiPrime(r) = 10;
    %     else
    %         PhiPrime(l) = 0;
    %         PhiPrime(r) = 0;
    %         EndCond = 1;
    %     end


        EndCond = 0;
        if (Time < 3)
            PhiPrime(l) = 10;
            PhiPrime(r) = 10;
        elseif (Time < 6.5)
            PhiPrime(l) = 5;
            PhiPrime(r) = 2.5;
        elseif (Time < 11)
            PhiPrime(l) = 5;
            PhiPrime(r) = 5;
        elseif (Time < 14.5)
            PhiPrime(l) = 5;
            PhiPrime(r) = 2.5;
        elseif (Time < 19)
            PhiPrime(l) = 5;
            PhiPrime(r) = 5;
        elseif (Time < 22)
            PhiPrime(l) = 5;
            PhiPrime(r) = 2.5;
        elseif (Time < 25)
            PhiPrime(l) = 5;
            PhiPrime(r) = 5;
        else
            PhiPrime(l) = 0;
            PhiPrime(r) = 0;
            EndCond = 1;
        end




        dx = ((dSl + dSr) / 2) * cos(theta);
        dy = ((dSl + dSr) / 2) * sin(theta);
        x = x + dx; % present position along the x-axis in the inertial frame
        y = y + dy; % present position along the y-axis in the inertial frame
        theta = theta + (dSr - dSl) / (2 * halfWheelbase);
        theta = Set2range(theta);
        pose = [x y theta]; % update the new position

        % Only for extra graphics
        %rho = sqrt((xg-x)^2+(yg-y)^2); % pythagoras theorem, sqrt(dx^2 + dy^2)    
        %lambda = atan2(yg-y, xg-x); % angle of the vector pointing from the robot to the goal in the inertial frame
        %alpha = lambda - theta; % angle of the vector pointing from the robot to the goal in the robot frame
        %alpha=Set2range(alpha);
        rho = 0;
        alpha = 0;
        beta = 0;


    else

        % Closed loop

        % Determine delta x, delta y, and delta theta in the inertial frame
        % write here...
        dx = ((dSl + dSr) / 2) * cos(theta);
        dy = ((dSl + dSr) / 2) * sin(theta);

        % Integrate the robot pose
        % write here...
        x = x + dx; % present position along the x-axis in the inertial frame
        y = y + dy; % present position along the y-axis in the inertial frame
        theta = theta + (dSr - dSl) / (2 * halfWheelbase);
        theta = Set2range(theta);

        % Compute rho, alpha, beta.
        pose = [x y theta]; % update the new position
        rho = sqrt((xg-x)^2+(yg-y)^2); % pythagoras theorem, sqrt(dx^2 + dy^2)
        lambda = atan2(yg-y, xg-x); % angle of the vector pointing from the robot to the goal in the inertial frame
        alpha = lambda - theta; % angle of the vector pointing from the robot to the goal in the robot frame
        alpha=Set2range(alpha);


        if BackwardOK % Backward speed allowed
            % If obstacle in "front" => go forward
            if(abs(alpha)<=pi/2)
                beta = thetag-lambda;
                Krho2 = Krho;
            else
                alpha=lambda-theta-pi;
                alpha=set2range(alpha);
                beta= thetag-lambda-pi;
                Krho2=-Krho;
            end
        else
            beta = thetag-lambda;
            Krho2 = Krho;
        end
        beta = Set2range(beta);


        % Compute omega and vu (control output)
        % write here...
        vu = Krho2 * rho; % [m/s]
        omega = Kalpha * alpha + Kbeta * beta; % [°/s]

        % Calculate wheel speeds
        M = [wheelRadius/2 wheelRadius/2; wheelRadius/(2*halfWheelbase) -wheelRadius/(2*halfWheelbase)];
        Minv = inv(M);
        PhiPrime = (Minv * ([vu omega]'))';

        % Fab
        %PhiPrime(1) = (vu + halfWheelbase*omega)/wheelRadius; % Vright
        %PhiPrime(2) = (vu - halfWheelbase*omega)/wheelRadius; % Vleft
        % or
        %M = [1 halfWheelbase; 1 -halfWheelbase]/wheelRadius;
        %PhiPrime = (M * [vu;omega])';

        %bend = rho > THRESHOLD && rho <= OUTBOUNDS;
        %bend = rho > 0.1 && rho <= 3;%OUTBOUNDS;
        %EndCond = rho < 0.1 || rho > 3;

        dtheta = abs(set2range(theta-thetag));
        EndCond = (rho < dist_error && dtheta < angle_error) || rho > 2;

    end % of if OpenLoop
end