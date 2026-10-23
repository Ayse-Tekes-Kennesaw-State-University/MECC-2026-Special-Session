function drawDisk(ax, angs, massPerHolder_g)
% Draws the disk from above, with holders (dark) in the pockets at angles ANGS (deg).
% MASSPERHOLDER_G is one mass for all holders, or one mass per holder.
cla(ax); hold(ax, 'on'); axis(ax, 'equal'); axis(ax, 'off');
if isscalar(massPerHolder_g), massPerHolder_g = repmat(massPerHolder_g, 1, numel(angs)); end
th = linspace(0, 2*pi, 200);
fill(ax, cos(th), sin(th), [0.89 0.87 0.83], 'EdgeColor', [0.09 0.10 0.12], 'LineWidth', 3);
plot(ax, [-1 1], [0 0], '--', 'Color', [0.65 0.63 0.58]);
plot(ax, [0 0], [-1 1], '--', 'Color', [0.65 0.63 0.58]);
rp = 0.6; rh = 0.3;
for q = [90 0 270 180]
    fill(ax, rp*cosd(q) + rh*cos(th), rp*sind(q) + rh*sin(th), [0.96 0.95 0.92], ...
        'EdgeColor', [0.55 0.53 0.48], 'LineWidth', 2);
end
for i = 1:numel(angs)
    q = angs(i);
    fill(ax, rp*cosd(q) + rh*cos(th), rp*sind(q) + rh*sin(th), [0.09 0.10 0.12], 'EdgeColor', 'none');
    fill(ax, rp*cosd(q) + 0.09*cos(th), rp*sind(q) + 0.09*sin(th), [0.76 0.25 0.05], 'EdgeColor', 'none');
    text(ax, rp*cosd(q), rp*sind(q) - 0.18, sprintf('%g g', massPerHolder_g(i)), 'Color', [1 1 1], ...
        'FontWeight', 'bold', 'FontSize', 11, 'HorizontalAlignment', 'center');
end
fill(ax, 0.08*cos(th), 0.08*sin(th), [0.09 0.10 0.12], 'EdgeColor', 'none');
xlim(ax, [-1.1 1.1]); ylim(ax, [-1.1 1.1]);
hold(ax, 'off');
end
