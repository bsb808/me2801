% gen_figures_intro_pcontrol.m  –  Figures for usv_casestudy_intro_pcontrol.tex
%
% Extracted from book/w05_blockdiagrams_pid/chapter/code/gen_figures.m
% (fig:p_step only).
%
% Writes PDFs to ../images/ (resolved relative to this script's location),
% so it can be invoked from any working directory.
% Requires MATLAB R2020a+ for exportgraphics.
%
% Plant parameters (nominal):
%   Surge:     K_v = 2.2,  tau_v = 1.5 s   =>  G_v(s) = 2.2 / (1.5s + 1)

SAVE_FIGS = true;   % set false to skip exporting PDFs to images/

%% ── Plant model ─────────────────────────────────────────────────────────────
K_v = 2.2;   tau_v = 1.5;
G_v = tf(K_v, [tau_v 1]);

%% ── Style constants ─────────────────────────────────────────────────────────
FW1 = 5.5;   FH1 = 2.6;   % single-panel (width x height, inches)
FS  = 10;                  % axis label / tick font size
LFS = 9;                   % legend font size

images_dir = fullfile(fileparts(mfilename('fullpath')), '..', 'images');
if SAVE_FIGS && ~exist(images_dir,'dir'),  mkdir(images_dir);  end  %#ok<UNRCH>
savepdf = @(fig,name) exportgraphics(fig, fullfile(images_dir,[name '.pdf']), 'ContentType','vector');

%% ── fig:p_step ──────────────────────────────────────────────────────────────
% P-only step response family on surge plant (unit step r = 1).
% Four values of K_P, each settling below 1 by e_ss = 1/(1 + K_P*K_v).

KP_vals = [0.3  0.7  1.5  4.0];
blues   = [0.7  0.8  1.00;   % lightest
           0.45 0.62 0.90;
           0.20 0.40 0.78;
           0.00 0.15 0.55];  % darkest
t1 = 0:0.005:10;

f1 = mkfig(1, FW1, FH1);
hold on;  box on;  grid on;
plot(t1, ones(size(t1)), 'k--', 'HandleVisibility','off');
for i = numel(KP_vals):-1:1
    KP   = KP_vals(i);
    T_cl = feedback(KP*G_v, 1);
    ess  = 1 / (1 + KP*K_v);          % m/s, for a 1 m/s step command
    tau_cl = tau_v / (1 + KP*K_v);    % s, closed-loop time constant
    plot(t1, step(T_cl, t1), 'Color',blues(i,:), ...
        'DisplayName', sprintf('K_P = %.1f (m/s)^{-1},  \\tau_{cl} = %.2f s,  e_{ss} = %.2f m/s', ...
                               KP, tau_cl, ess));
end
xlabel('Time (s)', 'FontSize',FS);
ylabel(['Speed, $r(t) = \mu(t)$, (m/s)'], 'FontSize',FS, 'Interpreter','latex');
legend('Interpreter','tex', 'FontSize',LFS, 'Location','southeast');
set(gca, 'FontSize',FS);
xlim([0 10]);  ylim([0 1.12]);

if SAVE_FIGS, savepdf(f1,'p_step'); end  %#ok<UNRCH>

%% ── Local functions ─────────────────────────────────────────────────────────

function f = mkfig(num, w, h)
% Create (or reuse) figure NUM, clear it, and set print dimensions.
    f = figure(num);
    clf(f, 'reset');
    set(f, 'Units','inches','Position',[1 1 w h], ...
           'PaperUnits','inches','PaperSize',[w h],'PaperPosition',[0 0 w h]);
end
