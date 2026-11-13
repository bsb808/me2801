% assign_blockdiagrams_soln.m  –  Figures for assign_blockdiagrams_soln.tex (HW4, Exercises 3 and 4)
%
% Writes assign_blockdiagrams_soln_ex3.pdf and _ex4.pdf next to this script.
% Requires MATLAB R2020a+ for exportgraphics.
SAVE_FIGS = true;

%% Plant and controller
K   = 5.1;    % m/s per unit throttle
tau = 1.3;    % s
G   = tf(K, [tau 1]);

% Exercise 3: minimum Kp for the rise-time requirement (first-order Tr = 2.2*tau_cl)
Tr_spec = 1.5;                         % s
Kp3     = (2.2*tau/Tr_spec - 1) / K;
T3      = feedback(Kp3*G, 1);
info3   = stepinfo(T3);

% Exercise 4: fixed Kp, with and without feedforward
Kp4     = 0.2;
Kff     = 1 / dcgain(G);               % feedforward gain
T4_p    = feedback(Kp4*G, 1);          % P only
T4_ff   = minreal(G*(Kp4 + Kff) / (1 + G*Kp4));   % T = G[C+F]/(1+GC)
info4_p  = stepinfo(T4_p);
info4_ff = stepinfo(T4_ff);

fprintf('Ex 3: Kp_min = %.3f, Tr = %.2f s, e_ss = %.3f\n', Kp3, info3.RiseTime, 1 - dcgain(T3));
fprintf('Ex 4: Kp = %.2f, Kff = %.3f\n', Kp4, Kff);
fprintf('  P only : Tr = %.2f s, e_ss = %.3f\n', info4_p.RiseTime,  1 - dcgain(T4_p));
fprintf('  P + FF : Tr = %.2f s, e_ss = %.3f\n', info4_ff.RiseTime, 1 - dcgain(T4_ff));

%% Style
FW = 5.5;  FH = 2.8;  FS = 10;  LFS = 9;
here    = fileparts(mfilename('fullpath'));
savepdf = @(fig,name) exportgraphics(fig, fullfile(here,[name '.pdf']), 'ContentType','vector');
t = 0:0.005:5;

%% Exercise 3: P-only step response, rise time marked
f3 = figure(1);  clf(f3, 'reset');
set(f3, 'Units','inches', 'Position',[1 1 FW FH]);
hold on;  box on;  grid on;
plot(t, ones(size(t)), 'k--', 'DisplayName','reference r(t) = 1');
plot(t, step(T3, t), 'b', 'DisplayName', sprintf('P only, K_p = %.3f', Kp3));
xline(info3.RiseTime, 'k:', sprintf('T_r = %.2f s', info3.RiseTime), ...
      'LabelVerticalAlignment','middle', 'FontSize',LFS, 'HandleVisibility','off');
xlabel('Time (s)', 'FontSize',FS);
ylabel('Speed (m/s)', 'FontSize',FS);
legend('Interpreter','tex', 'FontSize',LFS, 'Location','southeast');
set(gca, 'FontSize',FS);  ylim([0 1.15]);
if SAVE_FIGS, savepdf(f3, 'assign_blockdiagrams_soln_ex3'); end

%% Exercise 4: P-only vs P + feedforward
f4 = figure(2);  clf(f4, 'reset');
set(f4, 'Units','inches', 'Position',[1 1 FW FH]);
hold on;  box on;  grid on;
plot(t, ones(size(t)), 'k--', 'DisplayName','reference r(t) = 1');
plot(t, step(T4_p,  t), 'b', 'DisplayName', ...
     sprintf('P only, T_r = %.2f s, e_{ss} = %.2f', info4_p.RiseTime, 1 - dcgain(T4_p)));
plot(t, step(T4_ff, t), 'r', 'DisplayName', ...
     sprintf('P + feedforward, T_r = %.2f s, e_{ss} = %.2f', info4_ff.RiseTime, 1 - dcgain(T4_ff)));
xlabel('Time (s)', 'FontSize',FS);
ylabel('Speed (m/s)', 'FontSize',FS);
legend('Interpreter','tex', 'FontSize',LFS, 'Location','southeast');
set(gca, 'FontSize',FS);  ylim([0 1.15]);
if SAVE_FIGS, savepdf(f4, 'assign_blockdiagrams_soln_ex4'); end
