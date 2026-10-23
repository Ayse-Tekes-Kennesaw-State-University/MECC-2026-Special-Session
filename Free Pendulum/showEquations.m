function showEquations(ttl, lines, rowHeight)
% Draws a title and LaTeX lines in a clean figure (used by the "Show" checkboxes).
n   = numel(lines);
fig = figure('Color', 'w', 'Position', [100 100 780 rowHeight*n + 50]);
ax  = axes(fig, 'Position', [0 0 1 1], 'Visible', 'off');
xlim(ax, [0 1]); ylim(ax, [0 n + 0.8]);
text(ax, 0.03, n + 0.4, ttl, 'FontSize', 15, 'FontWeight', 'bold');
for k = 1:n
    text(ax, 0.05, n + 0.5 - k, lines(k), 'Interpreter', 'latex', 'FontSize', 17);
end
end
