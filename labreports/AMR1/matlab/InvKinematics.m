function [phi1, phi2] = InvKinematics(speedx, speedy, speedtTheta, theta, r, l);
XI_R = [1/2*r 1/2*r; 0 0; r/(2*l) -r/(2*l)];
R = [cos(theta) sin(theta) 0; -sin(theta) cos(theta) 0; 0 0 1];
phiVect = (XI_R\R) * [speedx; speedy; speedtTheta];
phi1 = phiVect(1);
phi2 = phiVect(2);