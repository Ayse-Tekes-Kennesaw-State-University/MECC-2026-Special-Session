function stopMotor(a, pins)
% Turns the motor off.
if ~isempty(a) && isvalid(a)
    writePWMDutyCycle(a, pins.ENA, 0);
    writeDigitalPin(a, pins.IN1, 0);
    writeDigitalPin(a, pins.IN2, 0);
end
fprintf("Motor stopped\n");
end
