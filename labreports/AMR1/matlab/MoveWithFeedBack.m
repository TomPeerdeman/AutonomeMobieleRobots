function MoveWithFeedBack(dx, dy, do, maxpower, r, l, kp, ka, kb, dt)
% Cumulative position in world coordinates
posx = 0;
posy = 0;
post = 0;

% Variance, at dest if the value is between var_ and -var_
varx = 3;
vary = 3;
vart = 3;

% Reset initial motor position to 0 rotations
NXT_ResetMotorPosition(MOTOR_B, false);
NXT_ResetMotorPosition(MOTOR_C, false);

while 1
    m1 = NXT_GetOutputState(MOTOR_B);
    m2 = NXT_GetOutputState(MOTOR_C);
    
    % phi1 en phi2 over a period of dt time
	v1 = (m1.RotationCount / 360 * 17.593) / dt
	v2 = (m2.RotationCount / 360 * 17.593) / dt
	
    NXT_ResetMotorPosition(MOTOR_B, false);
    NXT_ResetMotorPosition(MOTOR_C, false);
	
    % Get the speed we rotated with in dt time
	dott = GetThetaSpeed(v1, v2, r, l);
    % Update the current rotation
	post = post + (dott * dt)
	
    % Get the speed in x and y using our current rotation
	[dotx, doty] = GetSpeed(v1, v2, post, r)
	
    % Calculate our x and y pos since the start of this movement
	posx = posx + (dotx * dt);
	posy = posy + (doty * dt);

	error = [dx - posx; dy - posy; do - post];
	error
    
    % error is approx at 0, we are at the destination
	if error(1) >= -varx && error(1) <= varx && error(2) >= -vary && error(2) <= vary && error(3) >= -vart && error(3) <= vart
		break;
	end
	
    % Magic
	alpha = -error(3) + atan2(error(2), error(1));
	beta = -error(3) -alpha;
	
	v = kp * [error(1); error(2)];
	rotationspeed = ka * alpha + kb * beta;
	
	[phi1, phi2] = InvKinematics(v(1), v(2), rotationspeed, post, r, l);
	
    % Calculate the power, it is linair to the wheel rotation speed
	[p1, p2] = GetPower(phi1, phi2, maxpower);

	NXT_SetOutputState(MOTOR_B, p1, true, true, 'SPEED', 0, 'RUNNING',  0, 'dontreply');
	NXT_SetOutputState(MOTOR_C, p2, true, true, 'SPEED', 0, 'RUNNING',  0, 'dontreply');
	
	pause(dt);
end

% Stop motor's
NXT_SetOutputState(MOTOR_B, 0, true, false, 'IDLE', 0, 'RUNNING',  0, 'dontreply');
NXT_SetOutputState(MOTOR_C, 0, true, false, 'IDLE', 0, 'RUNNING',  0, 'dontreply');

function [p1, p2] = GetPower(phi1, phi2, maxpower)
d = phi1/phi2;
% Wheel 1 turns fastest and thus should have power = maxpower
if d > 0
	p1 = maxpower;
	p2 = 1/d * maxpower;
else
    % Wheel 2 turns fastest and thus should have power = maxpower
	p1 = d * maxpower;
	p2 = maxpower;
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