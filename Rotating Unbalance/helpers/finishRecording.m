function data = finishRecording(rec, accel, label, speed)
% Converts voltage to acceleration, using the at-rest samples as 0 g.
n  = rec.i;
t  = rec.t(1:n);  v = rec.v(1:n);  on = rec.on(1:n);  spd = rec.spd(1:n);
restIdx = ~on & t <= accel.baselineTime;
zeroV   = mean(v(restIdx));
acc     = (v - zeroV)/accel.sens*9.81;                % m/s^2
x       = acc(on);
data = struct('label', string(label), 't', t, 'acc', acc, 'volt', v, ...
              'motorOn', on, 'speedSetting', spd, 'speed', speed, 'zeroV', zeroV, ...
              'sampleRate', (n - 1)/(t(end) - t(1)), ...
              'rms', sqrt(mean((x - mean(x)).^2)), 'freqHz', NaN);
iOn = find(on);
if numel(iOn) > 32
    keep = on & t >= t(iOn(1)) + 1;                   % skip the 1 s spin-up
    data.freqHz = dominantFreq(t(keep), acc(keep));
end
end
