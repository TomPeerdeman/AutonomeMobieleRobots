function NXTBochtFeedback(radius, alpha, maxpower, richting)
dx = cos(alpha) * radius;
dy = sin(alpha) * radius;

% bocht naar rechts
if richting
    % Parameters: r=5.6cm, l = 5.8cm, kp = 3, ka = 8, kb = -1.5, dt=0.01
    MoveWithFeedBack(dx, -dy, -alpha, maxpower, 5.6, 5.8, 3, 8, -1.5, 0.01);
% bocht naar links
else
    % Parameters: r=5.6cm, l = 5.8cm, kp = 3, ka = 8, kb = -1.5, dt=0.01
    MoveWithFeedBack(dx, dy, alpha, maxpower, 5.6, 5.8, 3, 8, -1.5, 0.01);
end