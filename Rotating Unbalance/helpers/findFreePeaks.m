function data = findFreePeaks(data)
% Finds the release and the positive acceleration peaks of the free response.
% Each peak is refined with a parabola through the 3 samples around it.
t = data.t; x = data.acc;
held  = t <= 1;
thr   = max(0.3, 6*std(x(held)));
iRel  = find(abs(x) > thr & t > 0.5, 1);
if isempty(iRel)
    error('No release detected. Pull the cart about 3 cm, hold it, and release after the beep.');
end
iRel = max(iRel - 3, 1);
tr = t(iRel:end); xr = x(iRel:end);
if max(abs(xr)) > 0.9*3*9.81
    warning('Acceleration reached about 3 g, the ADXL335 limit, so the first peaks may be clipped. Pull the cart less (1-2 cm), or skip the clipped peaks.');
end
isPk = islocalmax(xr, 'MinProminence', 0.1*max(abs(xr)), 'FlatSelection', 'center') & xr > thr;
idx  = find(isPk);
tp = zeros(numel(idx), 1); ap = tp;
for j = 1:numel(idx)
    i = idx(j);
    tp(j) = tr(i); ap(j) = xr(i);
    if i > 1 && i < numel(xr)
        p = polyfit(tr(i-1:i+1) - tr(i), xr(i-1:i+1), 2);
        if p(1) < 0
            dt = -p(2)/(2*p(1));
            if abs(dt) < max(tr(i+1) - tr(i), tr(i) - tr(i-1))
                tp(j) = tr(i) + dt; ap(j) = polyval(p, dt);
            end
        end
    end
end
Peak = (1:numel(idx))';
data.peaks    = table(Peak, tp, ap, 'VariableNames', ["Peak", "Time_s", "Accel_m_s2"]);
data.tRelease = t(iRel);
if height(data.peaks) < 3
    warning('Only %d peaks found. Try a slightly larger pull (about 3 cm) and release from rest.', height(data.peaks));
end
end
