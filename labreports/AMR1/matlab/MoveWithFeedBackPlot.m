function MoveWithFeedBackPlot(dx, dy, do, maxpower, r, l, kp, ka, kb, dt)
% Cumulative position in world coordinates
posx = 0;
posy = 0;
post = 0;

% Variance, at dest if the value is between var_ and -var_
varx = 0.5;
vary = 0.2;
vart = pi/10.0;

% Reset initial motor position to 0 rotations
phi1 = 0;
phi2 = 0;

% Plot data
global xlist
global ylist
xlist = [0];
ylist = [0];

% Number of loops
n = 0;

while 1
	% Increase the number of steps
    n = n + 1;
    
    % phi1 en phi2 over a period of dt time
    v1 = phi1;
    v2 = phi2;
	
    % Get the speed we rotated with in dt time
	dott = GetThetaSpeed(v1, v2, r, l);
	
    % Get the speed in x and y using our current rotation
	[dotx, doty] = GetSpeed(v1, v2, post, r);
    
    % Update the current rotation
	post = post + (dott * dt);
	
    % Calculate our x and y pos since the start of this movement
	posx = posx + (dotx * dt);
	posy = posy + (doty * dt);
    
	% Set data for the plot for this timestep
    i = n + 1;
    xlist(i) = posx;
    ylist(i) = posy;

	error = [dx - posx; dy - posy; do - post]
    
    % error is approx at 0, we are at the destination
	if error(1) >= -varx && error(1) <= varx && error(2) >= -vary && error(2) <= vary && error(3) >= -vart && error(3) <= vart
		break;
	end
	
    
    rho = sqrt(error(1)^2 + error(2)^2);
	
    lambda = atan2(error(2), error(1));
	alpha = modangle(lambda - post);
	beta = modangle(do - lambda);
    
	v = kp * rho;
	rotationspeed = ka * alpha + kb * beta;
	
	[phi1, phi2] = InvKinematics(v, 0, rotationspeed, post, r, l);
    
    % Nog niet getest
    % phi1 = phi1 + (rand() / 10.0);
    % phi2 = phi2 + (rand() / 10.0);
	
	pause(dt);
end

% Print number of time steps
n

% Plot the trajectory
plot(xlist, ylist);

% Transform an angle to make sure it is in [-pi, pi]
function [a] = modangle(angle)
a = mod(angle, 2*pi);
if a > pi
    a = a - (2 * pi);
end

function [speedt] = GetThetaSpeed(phi1, phi2, r, l)
speedt = r/(2*l) * phi1 - r/(2*l) * phi2;

function [speedx, speedy] = GetSpeed(phi1, phi2, omega, r)
% Xi_I = R(omega)-1*Xi_R*[phi1; phi2]
Rinv = [cos(omega) -sin(omega); sin(omega) cos(omega)];
XI_R = [1/2*r*phi1 1/2*r*phi2; 0 0;];

XI_I = Rinv * XI_R;

speedx = XI_I(1);
speedy = XI_I(2);
