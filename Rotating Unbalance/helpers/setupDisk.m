function cfg = setupDisk(label, defaultPockets, defaultLoads, loadMass_g, holderMass_g)
% Opens a window where the team chooses which pockets hold a holder and how
% many loads go in EACH holder (holders can carry different numbers of loads).
% The picture shows where to put them. Returns the choices; cfg.ready is true
% only if the team clicked "Start motor".
% DEFAULTLOADS can be one number (same for every default pocket) or one
% number per pocket in DEFAULTPOCKETS.
names  = ["Top", "Right", "Bottom", "Left"];
angles = [90 0 270 180];
label  = string(label);
defaultPockets = string(defaultPockets);
cfg = struct('label', label, 'pockets', strings(1, 0), 'angles', [], ...
             'loads', [], 'mass_g', [], 'ready', false);

% Default number of loads for each of the four pockets
defLoads = ones(1, 4);
for k = 1:numel(defaultPockets)
    j = find(names == defaultPockets(k), 1);
    if ~isempty(j)
        if isscalar(defaultLoads), defLoads(j) = defaultLoads; else, defLoads(j) = defaultLoads(k); end
    end
end

fig = uifigure('Name', "Setup " + label + ": load the disk", 'Position', [100 100 680 560]);
movegui(fig, 'center');
fig.CloseRequestFcn = @(~, ~) finish(false);
gl = uigridlayout(fig, [4 2]);
gl.RowHeight   = {'fit', '1x', 'fit', 'fit'};
gl.ColumnWidth = {'1x', 250};

hdr = uilabel(gl, 'FontSize', 14, 'WordWrap', 'on', 'Text', sprintf( ...
    ['Setup %s. The motor is stopped. Tick each pocket that gets a holder and set how many %g g loads ' ...
     'go in THAT holder (they can be different). Put the holders on the disk as shown, then click Start motor.'], ...
    label, loadMass_g));
hdr.Layout.Row = 1; hdr.Layout.Column = [1 2];

ax = uiaxes(gl);
ax.Layout.Row = 2; ax.Layout.Column = 1;

pnl = uipanel(gl, 'Title', sprintf('Pocket  /  number of %g g loads', loadMass_g), ...
              'FontSize', 13, 'FontWeight', 'bold');
pnl.Layout.Row = 2; pnl.Layout.Column = 2;
pg = uigridlayout(pnl, [4 2]);
pg.RowHeight   = {'fit', 'fit', 'fit', 'fit'};
pg.ColumnWidth = {'1x', 80};
cb = gobjects(1, 4);
sp = gobjects(1, 4);
for k = 1:4
    cb(k) = uicheckbox(pg, 'Text', names(k), 'FontSize', 13, ...
        'Value', any(names(k) == defaultPockets), 'ValueChangedFcn', @(~, ~) redraw());
    cb(k).Layout.Row = k; cb(k).Layout.Column = 1;
    sp(k) = uispinner(pg, 'Limits', [0 10], 'Step', 1, 'RoundFractionalValues', 'on', ...
        'Value', defLoads(k), 'FontSize', 13, 'ValueChangedFcn', @(~, ~) redraw());
    sp(k).Layout.Row = k; sp(k).Layout.Column = 2;
end

info = uilabel(gl, 'FontSize', 13, 'WordWrap', 'on', 'Text', '');
info.Layout.Row = 3; info.Layout.Column = [1 2];

bl = uigridlayout(gl, [1 2], 'Padding', [0 0 0 0]);
bl.Layout.Row = 4; bl.Layout.Column = [1 2];
uibutton(bl, 'Text', 'Not yet', 'FontSize', 13, 'ButtonPushedFcn', @(~, ~) finish(false));
uibutton(bl, 'Text', 'Disk is loaded: Start motor', 'FontSize', 13, 'FontWeight', 'bold', ...
    'BackgroundColor', [0.76 0.25 0.05], 'FontColor', [1 1 1], 'ButtonPushedFcn', @(~, ~) finish(true));

askLoads = ~(isempty(defaultPockets) && all(defaultLoads == 0));
if ~askLoads          % no-load run: just show the empty disk and confirm
    hdr.Text = sprintf('Setup %s: run the system with NO load. Remove all holders from the disk, keep fingers clear, then click Start motor.', label);
    pnl.Visible = 'off';
    gl.ColumnWidth = {'1x', 0};
end
fprintf('Setup %s: set up the disk in the pop-up window...\n', label);
redraw();
uiwait(fig);          % waits here until the team clicks a button or closes the window

if cfg.ready
    if isempty(cfg.angles)
        fprintf('Setup %s: empty disk.\n', label);
    else
        parts = strings(1, numel(cfg.angles));
        for i = 1:numel(cfg.angles)
            parts(i) = sprintf('%s: %d x %g g = %g g', cfg.pockets(i), cfg.loads(i), loadMass_g, cfg.mass_g(i));
        end
        fprintf('Setup %s: %d holder(s). %s. Total added: %g g\n', label, ...
            numel(cfg.angles), strjoin(parts, '; '), sum(cfg.mass_g));
    end
    figure('Position', [100 100 260 260]);
    drawDisk(gca, cfg.angles, cfg.mass_g);
    title(sprintf('Setup %s as loaded', label));
    for k = 3:-1:1
        fprintf('Starting in %d...\n', k); drawnow; pause(1);
    end
else
    disp('Motor not started. Run this section again when the disk is ready.');
end

    function redraw()
        sel = [cb.Value];
        nLoads = [sp.Value];
        for kk = 1:4
            sp(kk).Enable = matlab.lang.OnOffSwitchState(sel(kk));
        end
        m = holderMass_g + nLoads(sel)*loadMass_g;
        drawDisk(ax, angles(sel), m);
        if any(sel)
            idx = find(sel);
            parts = strings(1, numel(idx));
            for ii = 1:numel(idx)
                parts(ii) = sprintf('%s %g g', names(idx(ii)), m(ii));
            end
            info.Text = sprintf('%d holder(s): %s.   Total added: %g g', nnz(sel), strjoin(parts, ', '), sum(m));
        else
            info.Text = 'Empty disk: no holders, no load.';
        end
    end

    function finish(ok)
        sel = [cb.Value];
        nLoads = [sp.Value];
        cfg.pockets = names(sel);
        cfg.angles  = angles(sel);
        cfg.loads   = nLoads(sel);
        cfg.mass_g  = holderMass_g + nLoads(sel)*loadMass_g;
        cfg.ready   = ok;
        delete(fig);
    end
end
