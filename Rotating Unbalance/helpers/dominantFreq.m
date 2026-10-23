function f0 = dominantFreq(t, x)
% Main frequency (Hz) of x(t), from an FFT of the evenly resampled signal.
f0 = NaN;
if numel(t) < 32, return, end
N  = numel(t);
tu = linspace(t(1), t(end), N)';
xu = interp1(t, x, tu);
xu = xu - mean(xu);
w  = 0.5 - 0.5*cos(2*pi*(0:N-1)'/(N - 1));          % Hann window
fs = (N - 1)/(tu(end) - tu(1));
X  = abs(fft(xu.*w));
f  = (0:N-1)'*fs/N;
keep = f > 0.5 & f < fs/2;
if ~any(keep), return, end
fk = f(keep);
[~, im] = max(X(keep));
f0 = fk(im);
end
