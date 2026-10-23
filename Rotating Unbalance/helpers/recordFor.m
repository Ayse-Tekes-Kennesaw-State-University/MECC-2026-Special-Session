function rec = recordFor(rec, a, accel, duration, motorOn, spd, demo)
% Reads the accelerometer as fast as possible for DURATION seconds.
tStart = toc(rec.t0);
while toc(rec.t0) - tStart < duration && rec.i < numel(rec.t)
    rec.i = rec.i + 1;
    tNow  = toc(rec.t0);
    rec.t(rec.i)   = tNow;
    rec.v(rec.i)   = readAccelVoltage(a, accel, motorOn, spd, tNow, demo);
    rec.on(rec.i)  = motorOn;
    rec.spd(rec.i) = spd;
end
end
