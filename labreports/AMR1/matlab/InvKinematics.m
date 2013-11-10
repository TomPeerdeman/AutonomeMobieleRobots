function [phi1, phi2] = InvKinematics(speedx, speedy, speedtTheta, theta, r, l)
% Xi_I = R(omega)-1*Xi_R*[phi1; phi2]
% R(omega) * Xi_I = Xi_R*[phi1; phi2]
% Xi_R-1 * R(omega) * Xi_I = [phi1; phi2]
XI_R = [1/2*r 1/2*r; 0 0; r/(2*l) -r/(2*l)];
R = [cos(theta) sin(theta) 0; -sin(theta) cos(theta) 0; 0 0 1];

phiVect = (XI_R\R) * [speedx; speedy; speedtTheta];
phi1 = phiVect(1);
phi2 = phiVect(2);