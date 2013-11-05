function NXTBochtErrorControl(radius, alpha, phi1, richting)
global error
error
outB = NXT_GetOutputState(MOTOR_B);
beforeB = outB.TachoCount+error(1);
outC = NXT_GetOutputState(MOTOR_C);
beforeC = outC.TachoCount+error(2);

s1 = (2*pi*(radius+5.85))/360 * alpha;
t = s1 / phi1;
s2 = (2*pi*(radius-5.85))/360 * alpha;
wentel1 = s1/17.593 * 360
wentel2 = s2/17.593 * 360
phi2 = s2/t

% bocht naar rechts
if richting
NXT_SetOutputState(MOTOR_C, phi1, true, true, 'SPEED', 0, 'RUNNING', wentel1-error(2), 'dontreply');
NXT_SetOutputState(MOTOR_B, phi2, true, true, 'SPEED', 0, 'RUNNING', wentel2-error(1), 'dontreply');
% bocht naar links
else
NXT_SetOutputState(MOTOR_C, phi2, true, true, 'SPEED', 0, 'RUNNING', wentel2-error(2), 'dontreply');
NXT_SetOutputState(MOTOR_B, phi1, true, true, 'SPEED', 0, 'RUNNING', wentel1-error(1), 'dontreply');
end
while(1)
    outB = NXT_GetOutputState(MOTOR_B);
    outC = NXT_GetOutputState(MOTOR_C);
    %pause(0.01)
    if strcmp(outB.RunStateName, 'IDLE')
        break
    end
end
outB = NXT_GetOutputState(MOTOR_B);
afterB = outB.TachoCount;
outC = NXT_GetOutputState(MOTOR_C);
afterC = outC.TachoCount;
diffB = abs(afterB-beforeB);
diffC = abs(afterC-beforeC);
error = [diffB-wentel2 diffC-wentel1];