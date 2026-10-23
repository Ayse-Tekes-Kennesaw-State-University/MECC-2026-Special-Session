function [rmsAll, freqAll] = compareRuns(cfg, labels)
% Plots all recorded setups on the same axes scale and returns their RMS
% acceleration and main shaking frequency (Hz).
n = numel(labels);
rmsAll = nan(n, 1); freqAll = nan(n, 1);
figure('Position', [100 100 760 140*n]);
tl = tiledlayout(n, 1, 'TileSpacing', 'compact');
axs = gobjects(n, 1);
for k = 1:n
    axs(k) = nexttile;
    f = char(labels(k));
    if isfield(cfg, f) && isfield(cfg.(f), 'data')
        d = cfg.(f).data;
        plot(d.t, d.acc, 'Color', [0.13 0.36 0.58]);
        rmsAll(k) = d.rms; freqAll(k) = d.freqHz;
        title(sprintf('Setup %s  (RMS = %.3f m/s^2)', f, d.rms));
    else
        title(sprintf('Setup %s: not recorded yet', f));
    end
    ylabel('m/s^2'); grid on;
end
linkaxes(axs, 'xy');
xlabel(tl, 'Time (s)');
end
