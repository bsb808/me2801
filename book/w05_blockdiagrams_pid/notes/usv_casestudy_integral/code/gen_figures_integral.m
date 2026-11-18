% gen_figures_integral.m  –  Figures for usv_casestudy_integral.tex
%
% Writes PDFs to ../images/ (resolved relative to this script's location),
% so it can be invoked from any working directory.
% Requires MATLAB R2020a+ for exportgraphics.
%
% Plant parameters (nominal, same as Part 1):
%   Surge:     K_v = 2.2,  tau_v = 1.5 s   =>  G_v(s) = 2.2 / (1.5s + 1)
%
% Figures:
%   pi_accumulate.pdf  –  P vs PI: speed, error (shaded area = integral), and
%                         the P and I contributions to throttle
%   pi_ki_family.pdf   –  speed error for several K_I (fixed K_P): all go to
%                         zero, small K_I just takes longer

SAVE_FIGS = true;   % set false to skip exporting PDFs to images/

%% ── Plant model and gains ───────────────────────────────────────────────────
K_v = 2.2;   tau_v = 1.5;
G_v = tf(K_v, [tau_v 1]);
s   = tf('s');

KP  = 0.7;          % (m/s)^-1, same mid-range gain used in Part 1
KI  = 0.4;          % (m/s)^-1 s^-1, gain for the illustration figure
u_ss = 1 / K_v;     % throttle needed to hold 1 m/s against drag

%% ── Style constants ─────────────────────────────────────────────────────────
FW1 = 5.5;   FH1 = 2.6;   % single-panel (width x height, inches)
FH3 = 6.0;                % three-panel height (inches)
FS  = 10;                 % axis label / tick font size
LFS = 9;                  % legend font size
cP  = [0.55 0.55 0.55];   % P-only (grey)
cPI = [0.00 0.15 0.55];   % PI (dark blue)
cI  = [0.80 0.40 0.00];   % integral contribution (orange)

images_dir = fullfile(fileparts(mfilename('fullpath')), '..', 'images');
if SAVE_FIGS && ~exist(images_dir,'dir'),  mkdir(images_dir);  end  %#ok<UNRCH>
savepdf = @(fig,name) exportgraphics(fig, fullfile(images_dir,[name '.pdf']), 'ContentType','vector');

%% ── fig:pi_accumulate ───────────────────────────────────────────────────────
% Unit step in desired speed.  P-only vs PI.  For PI, split the throttle into
% u_P = K_P e and u_I = K_I * integral(e).

t = (0:0.005:10)';

C_P  = KP;
C_PI = KP + KI/s;

y_P  = step(feedback(C_P *G_v, 1), t);
y_PI = step(feedback(C_PI*G_v, 1), t);
e_P  = 1 - y_P;
e_PI = 1 - y_PI;

uP_PI = KP * e_PI;                       % proportional contribution
uI_PI = KI * cumtrapz(t, e_PI);          % integral contribution
u_PI  = uP_PI + uI_PI;                   % total throttle
u_P   = KP * e_P;                        % P-only throttle

f1 = mkfig(1, FW1, FH3);
tl = tiledlayout(f1, 3, 1, 'TileSpacing','compact', 'Padding','compact');

% (a) speed
ax = nexttile(tl);  hold(ax,'on');  box(ax,'on');  grid(ax,'on');
plot(ax, t, ones(size(t)), 'k--', 'HandleVisibility','off');
plot(ax, t, y_P,  'Color',cP,  'DisplayName','P only');
plot(ax, t, y_PI, 'Color',cPI, 'DisplayName','PI');
ylabel(ax, 'Speed $y(t)$ (m/s)', 'Interpreter','latex');
legend(ax, 'Interpreter','tex', 'FontSize',LFS, 'Location','southeast');
ylim(ax, [0 1.15]);  set(ax, 'FontSize',FS);  title(ax, '(a)', 'FontWeight','normal');

% (b) error, with the area under the PI error shaded
ax = nexttile(tl);  hold(ax,'on');  box(ax,'on');  grid(ax,'on');
area(ax, t, e_PI, 'FaceColor',cI, 'FaceAlpha',0.25, 'EdgeColor','none', ...
     'DisplayName','\int e d\tau  (accumulated by integrator)');
plot(ax, t, e_P,  'Color',cP,  'DisplayName','P only');
plot(ax, t, e_PI, 'Color',cPI, 'DisplayName','PI');
ylabel(ax, 'Error $e(t)$ (m/s)', 'Interpreter','latex');
legend(ax, 'Interpreter','tex', 'FontSize',LFS, 'Location','northeast');
ylim(ax, [-0.05 1.05]);  set(ax, 'FontSize',FS);  title(ax, '(b)', 'FontWeight','normal');

% (c) throttle and its parts
ax = nexttile(tl);  hold(ax,'on');  box(ax,'on');  grid(ax,'on');
plot(ax, t, u_ss*ones(size(t)), 'k--', 'DisplayName','1/K_v  (throttle to hold 1 m/s)');
plot(ax, t, u_P,   'Color',cP,  'DisplayName','P only: u = K_P e');
plot(ax, t, uP_PI, ':', 'Color',cPI, 'DisplayName','PI: u_P = K_P e');
plot(ax, t, uI_PI, 'Color',cI,  'DisplayName','PI: u_I = K_I \int e d\tau');
plot(ax, t, u_PI,  'Color',cPI, 'DisplayName','PI: u = u_P + u_I');
ylabel(ax, 'Throttle $u(t)$ (--)', 'Interpreter','latex');
xlabel(ax, 'Time (s)');
legend(ax, 'Interpreter','tex', 'FontSize',LFS, 'Location','northeast');
ylim(ax, [0 1.7]);  set(ax, 'FontSize',FS);  title(ax, '(c)', 'FontWeight','normal');  % headroom so legend clears curves

if SAVE_FIGS, savepdf(f1,'pi_accumulate'); end  %#ok<UNRCH>

%% ── fig:pi_ki_family ────────────────────────────────────────────────────────
% Speed error for several K_I at fixed K_P.  Every K_I > 0 drives e -> 0;
% small K_I does so slowly (slow closed-loop pole near -K_v K_I/(1+K_v K_P)).

KI_vals = [0.1  0.4  1.0];
blues   = [0.45 0.62 0.90;
           0.20 0.40 0.78;
           0.00 0.15 0.55];
t2 = (0:0.01:30)';

f2 = mkfig(2, FW1, FH1);
hold on;  box on;  grid on;
plot(t2, zeros(size(t2)), 'k-', 'HandleVisibility','off');
e_P2 = 1 - step(feedback(KP*G_v, 1), t2);
plot(t2, e_P2, 'Color',cP, 'DisplayName', ...
     sprintf('P only (K_I = 0),  e_{ss} = %.2f m/s', 1/(1+KP*K_v)));
for i = 1:numel(KI_vals)
    KIi  = KI_vals(i);
    e_i  = 1 - step(feedback((KP + KIi/s)*G_v, 1), t2);
    p    = pole(feedback((KP + KIi/s)*G_v, 1));
    slow = max(real(p));               % slowest (closest to origin) pole
    plot(t2, e_i, 'Color',blues(i,:), 'DisplayName', ...
         sprintf('K_I = %.1f,  slowest pole Re(s) = %.2f s^{-1}', KIi, slow));
end
xlabel('Time (s)', 'FontSize',FS);
ylabel('Speed error $e(t)$ (m/s)', 'Interpreter','latex', 'FontSize',FS);
legend('Interpreter','tex', 'FontSize',LFS, 'Location','northeast');
set(gca, 'FontSize',FS);
xlim([0 30]);  ylim([-0.1 1.0]);

if SAVE_FIGS, savepdf(f2,'pi_ki_family'); end  %#ok<UNRCH>

%% ── Local functions ─────────────────────────────────────────────────────────

function f = mkfig(num, w, h)
% Create (or reuse) figure NUM, clear it, and set print dimensions.
    f = figure(num);
    clf(f, 'reset');
    set(f, 'Units','inches','Position',[1 1 w h], ...
           'PaperUnits','inches','PaperSize',[w h],'PaperPosition',[0 0 w h]);
end
