function NXTBocht(radius, alpha, phi1, richting)
% bereken de afstand voor het buitenste wiel
s1 = (2*pi*(radius+5.85))/360 * alpha;
% bereken de afstand voor het binnenste wiel
s2 = (2*pi*(radius-5.85))/360 * alpha;
% bereken de bijbehorende tijd
t = s1 / phi1;
% bereken de snelheid voor het binnenste wiel
phi2 = s2/t;
% bereken met behulp van de afstand het aantal te draaien graden per wiel
wentel1 = s1/17.593 * 360;
wentel2 = s2/17.593 * 360;

% bocht naar rechts
if richting
% Zet de gegeven power en het aantal berekende wentels per wiel
    NXT_SetOutputState(MOTOR_C, phi1, true, true, 'SPEED', 0, 'RUNNING', wentel1, 'dontreply');
    NXT_SetOutputState(MOTOR_B, phi2, true, true, 'SPEED', 0, 'RUNNING', wentel2, 'dontreply');

% bocht naar links
else
% Zet de gegeven power en het aantal berekende wentels per wiel
    NXT_SetOutputState(MOTOR_C, phi2, true, true, 'SPEED', 0, 'RUNNING', wentel2, 'dontreply');
    NXT_SetOutputState(MOTOR_B, phi1, true, true, 'SPEED', 0, 'RUNNING', wentel1, 'dontreply');
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