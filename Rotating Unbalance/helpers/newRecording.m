function rec = newRecording(totalTime)
% Preallocates a recording buffer (up to 2000 samples/s).
n   = ceil(totalTime*2000) + 100;
rec = struct('t', nan(n, 1), 'v', nan(n, 1), 'on', false(n, 1), ...
             'spd', zeros(n, 1), 'i', 0, 't0', tic);
end
