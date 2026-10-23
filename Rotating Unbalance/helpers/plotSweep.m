function plotSweep(data, wn)
% Plots the sweep recording and the RMS acceleration at each speed setting.
% The x-axis is the speed setting (PWM duty), which is always known exactly.
% With WN (rad/s) from the free response, it also estimates where r = 1 is:
% it fits a straight line of measured shaking frequency vs. speed setting,
% using only steps where the frequency reading is trustworthy, and marks the
% setting where that line reaches f_n. If the readings disagree, no line is drawn.
figure('Position', [100 100 760 520]);
tiledlayout(2, 1, 'TileSpacing', 'compact');
nexttile;
plot(data.t, data.acc, 'Color', [0.13 0.36 0.58]); grid on;
xlabel('Time (s)'); ylabel('Acceleration (m/s^2)');
title(sprintf('Setup %s: speed sweep', data.label));

spd  = data.sweepSpeeds(:);
rmsv = data.sweepRMS(:);
fr   = data.sweepFreq(:);

nexttile;
plot(spd, rmsv, '-o', 'LineWidth', 2, 'Color', [0.76 0.25 0.05], ...
     'MarkerFaceColor', [0.76 0.25 0.05]); hold on;
xlabel('Speed setting (PWM duty)'); ylabel('RMS acceleration (m/s^2)');
grid on; title('Where does the cart shake most?');

r = nan(size(spd));
if nargin > 1 && ~isempty(wn) && ~isnan(wn)
    % Noise level with the motor off, to ignore steps where the disk barely turns
    rest    = data.acc(~data.motorOn & data.t <= min(data.t(data.motorOn)));
    restRMS = sqrt(mean((rest - mean(rest)).^2));
    good = ~isnan(fr) & rmsv > 2*restRMS & fr < 0.4*data.sampleRate;
    fitOK = false;
    if nnz(good) >= 4
        s = spd(good); f = fr(good);
        p = polyfit(s, f, 1);
        res = abs(f - polyval(p, s));
        in  = res <= max(3*median(res), 0.2);          % drop readings far off the line
        if nnz(in) >= 4
            p  = polyfit(s(in), f(in), 1);
            R2 = 1 - sum((f(in) - polyval(p, s(in))).^2) / sum((f(in) - mean(f(in))).^2);
            fitOK = p(1) > 0 && R2 > 0.8;
        end
    end
    if fitOK
        r = 2*pi*polyval(p, spd)/wn;                  % estimated frequency ratio at each setting
        spd1 = (wn/(2*pi) - p(2))/p(1);               % setting where the disk turns at f_n
        if spd1 >= min(spd) && spd1 <= max(spd)
            xline(spd1, '--', 'r \approx 1', 'LabelVerticalAlignment', 'bottom');
        else
            fprintf('r = 1 is outside the swept speeds (estimated at setting %.2f).\n', spd1);
        end
    else
        fprintf(['The shaking frequency could not be measured reliably at each step ' ...
                 '(about %.0f samples/s), so r = 1 is not marked. Use the speed setting ' ...
                 'where the cart shook most.\n'], data.sampleRate);
    end
end

Speed_setting = spd; RMS_accel = rmsv; Freq_measured_Hz = fr; r_estimated = r;
disp(table(Speed_setting, RMS_accel, Freq_measured_Hz, r_estimated));
end
