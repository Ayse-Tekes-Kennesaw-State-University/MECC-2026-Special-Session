function plotAccel(data)
% Plots acceleration vs time for one run; the shaded band is when the motor is on.
figure('Position', [100 100 760 300]);
tOn  = data.t(find(data.motorOn, 1, 'first'));
tOff = data.t(find(data.motorOn, 1, 'last'));
if ~isempty(tOn)
    xregion(tOn, tOff, 'FaceColor', [0.76 0.25 0.05], 'FaceAlpha', 0.08); hold on;
end
plot(data.t, data.acc, 'Color', [0.13 0.36 0.58]);
xlabel('Time (s)'); ylabel('Acceleration (m/s^2)'); grid on;
title(sprintf('Setup %s: cart acceleration  (RMS while spinning = %.3f m/s^2)', data.label, data.rms));
subtitle(sprintf('%.0f samples/s; shaded = motor on', data.sampleRate));
end
