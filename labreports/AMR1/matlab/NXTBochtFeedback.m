function NXTBochtFeedback(radius, alpha, maxpower, richting)
dx = sin(alpha) * radius;

% bocht naar rechts
if richting
	dy = radius - cos(alpha) * radius;
% bocht naar links
else
	dy = radius + cos(alpha) * radius;
end

% Parameters: r=5.6cm, l = 5.8cm, kp = 3, ka = 8, kb = -1.5, dt=0.1
MoveWithFeedBack(dx, dy, alpha, maxpower, 5.6, 5.8, 3, 8, -1.5, 0.1);
