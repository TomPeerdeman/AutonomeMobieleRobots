function NXTLineErrorControl(phi, wentels)
global error
error
outB = NXT_GetOutputState(MOTOR_B);
beforeB = outB.TachoCount;
outC = NXT_GetOutputState(MOTOR_C);
beforeC = outC.TachoCount;
NXT_SetOutputState(MOTOR_B, phi, true, true, 'SPEED', 0, 'RUNNING', wentels-error(1), 'dontreply');
NXT_SetOutputState(MOTOR_C, phi, true, true, 'SPEED', 0, 'RUNNING', wentels-error(2), 'dontreply');
while(1)
    outB = NXT_GetOutputState(MOTOR_B);
    outC = NXT_GetOutputState(MOTOR_C);
    %pause(0.01)
    if strcmp(outB.RunStateName, 'IDLE') && strcmp(outC.RunStateName, 'IDLE')
        break
    end
end

outB = NXT_GetOutputState(MOTOR_B);
afterB = outB.TachoCount;
outC = NXT_GetOutputState(MOTOR_C);
afterC = outC.TachoCount;
diffB = abs(afterB-beforeB)+error(1);
diffC = abs(afterC-beforeC)+error(2);
error = [diffB-wentels diffC-wentels];