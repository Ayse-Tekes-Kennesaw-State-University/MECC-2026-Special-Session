function plotFreeResponse(data)
% Plots the free response with numbered peaks.
figure('Position', [100 100 760 320]);
plot(data.t, data.acc, 'Color', [0.13 0.36 0.58]); hold on;
xline(data.tRelease, ':', 'release');
plot(data.peaks.Time_s, data.peaks.Accel_m_s2, 'v', 'MarkerFaceColor', 'r', 'MarkerEdgeColor', 'r');
text(data.peaks.Time_s, data.peaks.Accel_m_s2, "  " + string(data.peaks.Peak), ...
     'VerticalAlignment', 'bottom', 'FontWeight', 'bold');
xlabel('Time (s)'); ylabel('Acceleration (m/s^2)'); grid on;
title('Free response after release');
subtitle(sprintf('%.0f samples/s; numbered peaks for the logarithmic decrement', data.sampleRate));
end
