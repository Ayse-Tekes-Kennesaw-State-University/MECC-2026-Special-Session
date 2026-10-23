function demo = demoSettings(cfgRun)
% Rig values used only to simulate data in demo mode.
demo = struct('maxHz', 6, 'wn', 2*pi*3.5, 'zeta', 0.04, 'M', 0.2, 'e', 0.03, 'net_g', 0);
if isstruct(cfgRun) && ~isempty(cfgRun.angles)
    ang = deg2rad(cfgRun.angles);
    demo.net_g = norm([sum(cfgRun.mass_g.*cos(ang)), sum(cfgRun.mass_g.*sin(ang))]);
end
end
