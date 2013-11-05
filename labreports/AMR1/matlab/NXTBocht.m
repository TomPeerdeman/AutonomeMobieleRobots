function NXTBocht(radius, alpha, phi1, richting)

s1 = (2*pi*(radius+5.85))/360 * alpha;
s2 = (2*pi*(radius-5.85))/360 * alpha;
t = s1 / phi1;
phi2 = s2/t
wentel1 = s1/17.593 * 360
wentel2 = s2/17.593 * 360

% bocht naar rechts
if richting
NXT_SetOutputState(MOTOR_C, phi1, true, true, 'SPEED', 0, 'RUNNING', wentel1, 'dontreply');
NXT_SetOutputState(MOTOR_B, phi2, true, true, 'SPEED', 0, 'RUNNING', wentel2, 'dontreply');
% bocht naar links
else
NXT_SetOutputState(MOTOR_C, phi2, true, true, 'SPEED', 0, 'RUNNING', wentel2, 'dontreply');
NXT_SetOutputState(MOTOR_B, phi1, true, true, 'SPEED', 0, 'RUNNING', wentel1, 'dontreply');
end
while(1)
    outB = NXT_GetOutputState(MOTOR_B);
    outC = NXT_GetOutputState(MOTOR_C);
    %pause(0.01)
    if strcmp(outB.RunStateName, 'IDLE') && strcmp(outC.RunStateName, 'IDLE')
        break
    end
end