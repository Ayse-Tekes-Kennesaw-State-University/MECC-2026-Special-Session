function pk = findSwingPeaks(run)
% Finds peaks on the release side, measured from the final rest angle.
th    = run.theta(:); t = run.t(:);
nTail = max(1, round(0.15*numel(th)));
rest  = mean(th(end-nTail+1:end));                   % final rest angle
x     = th - rest;
[~, iMax] = max(abs(x));  s = sign(x(iMax)); if s == 0, s = 1; end
x     = s*x;                                         % release side positive
isPk  = islocalmax(x, 'MinProminence', 0.5, 'FlatSelection', 'center') & x > 0.5;
idx   = find(isPk);
Peak  = (1:numel(idx))';
Time_s    = t(idx);
Theta_deg = x(idx);
pk = table(Peak, Time_s, Theta_deg);
pk.Properties.UserData = struct('rest', rest, 'sign', s);
if height(pk) < 2
    warning('Fewer than 2 peaks found. Re-run the setup and release from rest.');
end
end
