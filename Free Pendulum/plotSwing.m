function plotSwing(run, pk)
figure;
plot(run.t, run.theta, 'LineWidth', 2); hold on;
rest = pk.Properties.UserData.rest; s = pk.Properties.UserData.sign;
yline(rest, ':', sprintf('rest = %.2f deg', rest));
yPk = rest + s*pk.Theta_deg;
plot(pk.Time_s, yPk, 'v', 'MarkerFaceColor', 'r', 'MarkerEdgeColor', 'r');
text(pk.Time_s, yPk, "  " + string(pk.Peak), 'VerticalAlignment', 'bottom', 'FontWeight', 'bold');
xlabel('Time (s)'); ylabel('Angular Displacement (deg)');
title(sprintf('Free Pendulum Setup %s (release about %g deg)', run.label, run.releaseAngle));
grid on;
end
