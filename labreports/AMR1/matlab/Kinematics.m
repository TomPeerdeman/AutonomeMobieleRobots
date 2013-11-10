function [speedx, speedy, speedtheta] = Kinematics(phi1, phi2, theta, r, l);
Rinv = [cos(theta) -sin(theta) 0; sin(theta) cos(theta) 0; 0 0 1];
XI_R = [1/2*r 1/2*r; 0 0; r/(2*l) -r/(2*l)];
XI_I = Rinv * XI_R * [phi1; phi2];
speedx = XI_I(1);
speedy = XI_I(2);
speedtheta = XI_I(3);