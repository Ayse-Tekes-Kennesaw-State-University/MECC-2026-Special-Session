function data = sweepMotor(a, pins, speeds, holdTime, accel, cfgRun)
% Steps the motor through SPEEDS (PWM duty 0-1), holding each for HOLDTIME s,
% while recording the ADXL335. Returns the data and the RMS at each setting.
cleanup = onCleanup(@() stopMotor(a, pins)); %#ok<NASGU>
demo    = demoSettings(cfgRun);
rec     = newRecording(accel.baselineTime + numel(speeds)*holdTime + accel.coastTime);

fprintf('Recording %g s at rest...\n', accel.baselineTime);
rec = recordFor(rec, a, accel, accel.baselineTime, false, 0, demo);
for s = speeds
    s = min(max(s, 0), 1); %#ok<FXSET>
    setMotor(a, pins, s);
    fprintf('Speed setting %.2f  (%.0f%% PWM)\n', s, s*100);
    drawnow;
    rec = recordFor(rec, a, accel, holdTime, true, s, demo);
end
setMotor(a, pins, 0);
rec = recordFor(rec, a, accel, accel.coastTime, false, 0, demo);

data = finishRecording(rec, accel, cfgRun.label, NaN);
data.sweepSpeeds = speeds(:);
data.sweepRMS    = nan(numel(speeds), 1);
data.sweepFreq   = nan(numel(speeds), 1);
for k = 1:numel(speeds)
    idx = data.speedSetting == min(max(speeds(k), 0), 1) & data.motorOn;
    if ~any(idx), continue, end
    tk  = data.t(idx);
    keep = idx & data.t >= tk(1) + 0.3*holdTime;      % skip the speed-change transient
    x = data.acc(keep);
    if numel(x) > 2, data.sweepRMS(k) = sqrt(mean((x - mean(x)).^2)); end
    data.sweepFreq(k, 1) = dominantFreq(data.t(keep), x);
end
[~, iMax] = max(data.sweepRMS);
fprintf('Largest RMS acceleration at speed setting %.2f\n', speeds(iMax));
end
