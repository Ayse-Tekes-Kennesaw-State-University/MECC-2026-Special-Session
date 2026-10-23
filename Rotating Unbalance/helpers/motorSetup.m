function pins = motorSetup(a)
% Configures the L298N motor-driver pins and makes sure the motor is off.
pins = struct('IN1', 'D8', 'IN2', 'D7', 'ENA', 'D9');
if isempty(a)
    disp("Demo mode: no Arduino. Motor commands will only be printed.");
    return
end
configurePin(a, pins.IN1, 'DigitalOutput');
configurePin(a, pins.IN2, 'DigitalOutput');
configurePin(a, pins.ENA, 'PWM');
stopMotor(a, pins);
disp("Arduino connected and motor pins configured.");
end
