function NXTBocht(radius, alpha, richting)
% bereken de afstand voor het buitenste wiel
%s1 = (2*pi*(radius+5.85))/360 * alpha;
% bereken de afstand voor het binnenste wiel
%s2 = (2*pi*(radius-5.85))/360 * alpha;
% bereken de bijbehorende tijd
%t = s1 / phi1;
% bereken de snelheid voor het binnenste wiel

%phi2 = s2/t;
% bereken met behulp van de afstand het aantal te draaien graden per wiel
%wentel1 = s1/17.593 * 360;
%wentel2 = s2/17.593 * 360;


% bocht naar rechts
if richting
    [phi1, phi2] = InvKinematics(cos(radius), sin(radius), 0, alpha, 5.6, 5.85)
    [p1, p2] = GetPower(phi1, phi2, 40);
% Zet de gegeven power en het aantal berekende wentels per wiel
    NXT_SetOutputState(MOTOR_C, p1, true, true, 'SPEED', 0, 'RUNNING', phi1, 'dontreply');
    NXT_SetOutputState(MOTOR_B, p2, true, true, 'SPEED', 0, 'RUNNING', phi2, 'dontreply');

% bocht naar links
else
    [phi1, phi2] = InvKinematics(cos(radius), sin(radius), alpha, 0, 5.6, 5.85);
    [p1, p2] = GetPower(phi1, phi2, 40);
% Zet de gegeven power en het aantal berekende wentels per wiel
    NXT_SetOutputState(MOTOR_C, p2, true, true, 'SPEED', 0, 'RUNNING', phi2, 'dontreply');
    NXT_SetOutputState(MOTOR_B, p1, true, true, 'SPEED', 0, 'RUNNING', phi1, 'dontreply');
end

% Wacht tot de beweging klaar is
while(1)
    outB = NXT_GetOutputState(MOTOR_B);
    outC = NXT_GetOutputState(MOTOR_C);
    % Zodra beide motors klaar zijn met bewegen, break
    if strcmp(outB.RunStateName, 'IDLE') && strcmp(outC.RunStateName, 'IDLE')
        break
    end
end

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