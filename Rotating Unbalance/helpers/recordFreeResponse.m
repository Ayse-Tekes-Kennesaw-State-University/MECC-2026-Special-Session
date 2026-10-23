function data = recordFreeResponse(a, accel, duration)
% Free-vibration test: the cart is pulled about 3 cm, held, and released.
% Records 1 s while held (sets 0 g), then DURATION s after "RELEASE NOW".
msg = sprintf(['Free response test (motor OFF, no holders on the disk).\n\n' ...
    '1. One teammate pulls the cart about 3 cm to the right or left and holds it still.\n' ...
    '2. Click Start recording.\n' ...
    '3. After the beep and RELEASE NOW, let go of the cart (do not push it).\n\n' ...
    'Recording lasts %g s.'], duration);
answer = questdlg(msg, 'Free response test', 'Start recording', 'Cancel', 'Start recording');
if ~strcmp(answer, 'Start recording')
    error('Free response test cancelled. Run this section again when you are ready.');
end
demo = struct('free', true, 'tRelease', 1.2, 'wn', 2*pi*3.5, 'zeta', 0.04);
rec  = newRecording(accel.baselineTime + duration);
fprintf('Hold the cart still...\n'); drawnow;
rec = recordFor(rec, a, accel, accel.baselineTime, false, 0, demo);
beep;
fprintf('>>> RELEASE NOW <<<\n'); drawnow;
rec  = recordFor(rec, a, accel, duration, false, 0, demo);
data = finishRecording(rec, accel, "Free", 0);
fprintf('Recorded %d samples at about %.0f samples/s.\n', numel(data.t), data.sampleRate);
end
