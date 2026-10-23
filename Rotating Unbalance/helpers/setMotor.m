function setMotor(a, pins, speed)
% Runs the motor forward at SPEED (PWM duty cycle 0-1).
if isempty(a), return, end
writeDigitalPin(a, pins.IN1, 1);
writeDigitalPin(a, pins.IN2, 0);
writePWMDutyCycle(a, pins.ENA, speed);
end
