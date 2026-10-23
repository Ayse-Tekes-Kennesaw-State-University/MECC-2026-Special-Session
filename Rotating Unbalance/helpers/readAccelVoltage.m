function v = readAccelVoltage(a, accel, motorOn, spd, tNow, demo)
% Reads the ADXL335 voltage. In demo mode (no Arduino) it simulates the cart.
if ~isempty(a)
    v = readVoltage(a, accel.pin);
    return
end
pause(0.004);                                         % about 250 samples/s
acc = 0.05*randn;                                     % sensor noise (m/s^2)
if isfield(demo, 'free')                              % free response after release
    tau = tNow - demo.tRelease;
    if tau >= 0
        w = demo.wn; z = demo.zeta; s1 = sqrt(1 - z^2); X0 = 0.03;
        x  = X0*exp(-z*w*tau)*(cos(w*s1*tau) + z/s1*sin(w*s1*tau));
        xd = -X0*w/s1*exp(-z*w*tau)*sin(w*s1*tau);
        acc = acc - 2*z*w*xd - w^2*x;
    end
    v = accel.zeroV + acc/9.81*accel.sens;
    return
end
if motorOn && spd > 0
    w  = 2*pi*demo.maxHz*spd;                         % disk speed (rad/s)
    r  = w/demo.wn;
    X  = (demo.net_g/1000*demo.e/demo.M) * r^2 / sqrt((1 - r^2)^2 + (2*demo.zeta*r)^2);
    acc = acc + X*w^2*sin(w*tNow) + 0.03*sin(2*pi*3*tNow);
end
v = accel.zeroV + acc/9.81*accel.sens;
end
