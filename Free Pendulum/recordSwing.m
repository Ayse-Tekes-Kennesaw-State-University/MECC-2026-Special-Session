function run = recordSwing(encoder, label, releaseAngle, duration, sampleTime, countsPerRev, L)
% Waits for the arm to be lifted and released, then records theta(t) for DURATION seconds.
nMax  = ceil(duration/sampleTime) + 1;
t     = nan(nMax, 1);
theta = nan(nMax, 1);

if ~isempty(encoder)
    resetCount(encoder);                              % arm hanging at rest = 0 deg
    readAngle = @() double(readCount(encoder))/countsPerRev*360;
    fprintf('Start moving the pendulum... lift to about %g deg, hold still, then release.\n', releaseAngle);
    drawnow;

    % Wait for release: arm lifted past 5 deg, then moving back from its highest point
    tWait = tic; peak = 0;
    while true
        th = readAngle();
        if abs(th) > abs(peak), peak = th; end
        if abs(peak) > 5 && abs(th) < abs(peak) - 1.5, break; end
        if toc(tWait) > 60
            warning('No release detected after 60 s; recording anyway.'); break;
        end
    end

    % Record every sampleTime
    i = 1; t0 = tic;
    while toc(t0) <= duration && i <= nMax
        t(i)     = toc(t0);
        theta(i) = readAngle();
        while toc(t0) <= i*sampleTime   % wait for the next sample time
        end
        i = i + 1;
    end
    keep = ~isnan(t); t = t(keep); theta = theta(keep);
else
    % Demo mode: simulate a nonlinear, lightly damped pendulum (slightly "longer" than L)
    Leff = 1.04*L; wnS = sqrt(9.81/Leff); zS = 0.02;
    f  = @(tt, x) [x(2); -2*zS*wnS*x(2) - wnS^2*sin(x(1))];
    t  = (0:sampleTime:duration)';
    [~, X] = ode45(f, t, [deg2rad(releaseAngle); 0]);
    res = 360/countsPerRev;
    theta = round((rad2deg(X(:,1)) + 0.4)/res)*res;   % encoder quantization + small offset
end
fprintf('Setup %s recorded: %d samples over %.1f s.\n', label, numel(t), t(end));
run = struct('label', string(label), 'releaseAngle', releaseAngle, 't', t, 'theta', theta);
end
