function NXTLine(phi, wentels)
NXT_SetOutputState(MOTOR_B, phi, true, true, 'SPEED', 0, 'RUNNING', wentels, 'dontreply');
NXT_SetOutputState(MOTOR_C, phi, true, true, 'SPEED', 0, 'RUNNING', wentels, 'dontreply');

while(1)
    outB = NXT_GetOutputState(MOTOR_B);
    outC = NXT_GetOutputState(MOTOR_C);
    %pause(0.01)
    if strcmp(outB.RunStateName, 'IDLE') && strcmp(outC.RunStateName, 'IDLE')
        break
    end
end