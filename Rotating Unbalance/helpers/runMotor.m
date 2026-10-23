function data = runMotor(a, pins, speed, runTime, accel, cfgRun)
% Spins the disk at SPEED (PWM duty 0-1) for RUNTIME s and records the ADXL335.
% Records ACCEL.baselineTime s at rest first (sets the 0 g voltage) and
% ACCEL.coastTime s after the motor stops. The motor also stops if the run
% is interrupted (Stop button or Ctrl+C).
speed   = min(max(speed, 0), 1);
cleanup = onCleanup(@() stopMotor(a, pins)); %#ok<NASGU>
demo    = demoSettings(cfgRun);
rec     = newRecording(accel.baselineTime + runTime + accel.coastTime);

fprintf('Recording %g s at rest...\n', accel.baselineTime);
rec = recordFor(rec, a, accel, accel.baselineTime, false, 0, demo);

setMotor(a, pins, speed);
fprintf('Motor ON: %.0f%% PWM for %g s, recording acceleration...\n', speed*100, runTime);
rec = recordFor(rec, a, accel, runTime, true, speed, demo);

setMotor(a, pins, 0);
rec = recordFor(rec, a, accel, accel.coastTime, false, 0, demo);

data = finishRecording(rec, accel, cfgRun.label, speed);
fprintf('Done: %d samples at about %.0f samples/s. RMS acceleration while spinning: %.3f m/s^2\n', ...
        numel(data.t), data.sampleRate, data.rms);
end
