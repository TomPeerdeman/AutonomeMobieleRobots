function NXTLine(phi, afstand)
% bereken het aantal graden bij de bijbehorende afstand
wentels = afstand/17.593 * 360;
% Zet de gegeven power en het aantal berekende wentels
NXT_SetOutputState(MOTOR_B, phi, true, true, 'SPEED', 0, 'RUNNING', wentels, 'dontreply');
NXT_SetOutputState(MOTOR_C, phi, true, true, 'SPEED', 0, 'RUNNING', wentels, 'dontreply');

% Wacht tot de beweging klaar is
while(1)
    outB = NXT_GetOutputState(MOTOR_B);
    outC = NXT_GetOutputState(MOTOR_C);
    % Zodra beide motors klaar zijn met bewegen, break
    if strcmp(outB.RunStateName, 'IDLE') && strcmp(outC.RunStateName, 'IDLE')
        break
    end
end