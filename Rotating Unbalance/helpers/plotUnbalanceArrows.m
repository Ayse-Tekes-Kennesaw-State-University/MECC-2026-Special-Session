function netUnbalance_g = plotUnbalanceArrows(holderAngles, holderMasses_g, labels)
% Draws each holder's unbalance arrow (length = its mass) and the net arrow (red)
% for every setup. Net unbalance is in g*e (e = pocket radius).
n = numel(holderAngles);
netUnbalance_g = zeros(n, 1);
allM  = [holderMasses_g{:}];
scale = 1 / max([allM, 1e-9]);
figure('Position', [100 100 260*n 300]);
tiledlayout(1, n, 'TileSpacing', 'compact');
th = linspace(0, 2*pi, 200);
for j = 1:n
    nexttile; hold on; axis equal off;
    fill(1.4*cos(th), 1.4*sin(th), [0.89 0.87 0.83], 'EdgeColor', [0.1 0.1 0.12], 'LineWidth', 2);
    ang = deg2rad(holderAngles{j});
    m   = holderMasses_g{j};
    for i = 1:numel(ang)
        quiver(0, 0, scale*m(i)*cos(ang(i)), scale*m(i)*sin(ang(i)), 0, ...
            'Color', [0.45 0.45 0.45], 'LineWidth', 2, 'MaxHeadSize', 0.5);
        plot(cos(ang(i)), sin(ang(i)), 'o', 'MarkerSize', 14, ...
            'MarkerFaceColor', [0.1 0.1 0.12], 'MarkerEdgeColor', 'none');
    end
    net = [sum(m.*cos(ang)), sum(m.*sin(ang))];
    netUnbalance_g(j) = round(norm(net), 2);
    if netUnbalance_g(j) > 1e-6
        quiver(0, 0, scale*net(1), scale*net(2), 0, 'Color', [0.76 0.25 0.05], ...
            'LineWidth', 3.5, 'MaxHeadSize', 0.6);
    end
    plot(0, 0, 'k.', 'MarkerSize', 20);
    title(sprintf('%s:  net = %g g x e', labels(j), netUnbalance_g(j)));
    xlim([-1.6 1.6]); ylim([-1.6 1.6]);
end
end
