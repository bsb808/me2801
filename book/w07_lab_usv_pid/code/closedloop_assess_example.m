% Closed-Loop Step Response Analysis for Lab 2 - PID+FF tuning
%
% This example illustrates the processing of the Lab 2 log files.
% The script generates plots of speed and yaw PID experiments 
% and overlays the gains and performance metrics

%% Instructions
% 1) Change the filename to match your log file
% 2) Change "speed" or "yaw" to match the experiment you ran
% 3) Run the script
% 4) Zoom in on Figure 1 to estimate the parameters 
%    listed in the %% Isolate the step response section.
% 5) Re-run the script to generate the second figure which
%    uses your inputs from 4) and the timeseries to calculate
%    the transient and steady-state performance metrics.

%% Specify the data file and the experiment type (speed or yaw)
clear;
close("all");

% You will need to change this data file name.
fname      = "./closedloop_assess_example.mat";
experiment = "speed";   % "speed" or "yaw".  This controls the second plot

%% Load log data as a structure and save filename for later
d = load(fname);
[dirpath, name, ext] = fileparts(fname);
[~, lastDir] = fileparts(dirpath);
flabel = fullfile(lastDir, name + ext);


%% Print the pertinent controller parameters
p = d.params;
fprintf("\n--- Surge speed PID (ATC_SPEED_*) ---\n");
fprintf("  P: %g    I: %g    D: %g    FF: %g\n", ...
    p.ATC_SPEED_P, p.ATC_SPEED_I, p.ATC_SPEED_D, p.ATC_SPEED_FF);
fprintf("\n--- Yaw-rate PID (ATC_STR_RAT_*) ---\n");
fprintf("  P: %g    I: %g    D: %g    FF: %g\n", ...
    p.ATC_STR_RAT_P, p.ATC_STR_RAT_I, p.ATC_STR_RAT_D, p.ATC_STR_RAT_FF);


%% Plot the full response for both controllers - both speed and yaw
t0 = min([d.PIDA_timestamp(1), d.PIDS_timestamp(1)]);

% Speed = PIDA
figure(1);
clf();
ax1 = subplot(211);
plot(d.PIDA_timestamp-t0, d.PIDA_Tar, "b--", ...
    "DisplayName", "PIDA\_Tar (setpoint/cmd)");
hold on;
plot(d.PIDA_timestamp-t0, d.PIDA_Act, "r-",  ...
    "DisplayName", "PIDA\_Act (actual)");
hold off;
ylabel("Speed (m/s)");
legend("Location", "best");
title(sprintf("Speed Loop (PIDA) <%s>", flabel), "Interpreter", "none");
grid on;

% Steering = PIDS
ax2 = subplot(212);
plot(d.PIDS_timestamp-t0, d.PIDS_Tar, "b--", "DisplayName", "PIDS\_Tar (setpoint/cmd)");
hold on;
plot(d.PIDS_timestamp-t0, d.PIDS_Act, "r-",  "DisplayName", "PIDS\_Act (actual)");
hold off;
ylabel("Yaw rate (rad/s)");
legend("Location", "best");
title(sprintf("Steering Loop (PIDS) <%s>", flabel), "Interpreter", "none");
grid on;
linkaxes([ax1, ax2], "x");

%% Isolate the step response
% From the generated figures above, 
% find the step boundaries (in elapsed seconds)
% and the observed steady-state value of the measurement.
% Zoom, pan and the  'data tip' graphical tool is helpful for this.

% The `start` of the time step is the time value when the 
% step input command began.  This is where the _Tar value first changes
t_step_start = 3.28;     

% The `end` of the time step is ideally a few seconds (say 5) after both the 
% _Tar and _Act values reach their steady state.   
t_step_end   = 14.0;   % elapsed seconds when response has settled


% Record the Target and Actual amplitudes by measuring with from the graph,
% The reason we use human input here instead of estimating these values
% is that there are some edge cases, such as when the signal does not reach
% steady-state, that can be prevented with human input.
% These values are used to cacluate the steady-state error

% Target amplitude - the steady state value of the _Tar value.
% For inputs that were done by a script, this may be an exact
% constant, but for inputs from the R/C transmitter (pilot) there will be 
% small variations.  
tar_amplitude = 2.15;   

% Actual steady-state - the steady state value of the _act value, the 
% response to the step input.  
act_steady_state = 1.99;     

%% Step Metrics and Isolated Plot
% Plot options: the window starts X seconds before t_step_start, and
% textbox_fontsize sets the size of the legends and corner text boxes.
X                = 2.0;   % plot lead-in (s)
textbox_fontsize = 9;     % pt

figure(2);

% Elapsed-time vectors from raw log timestamps
t_pids = d.PIDS_timestamp - t0;
t_pida = d.PIDA_timestamp - t0;
t_plot_start = t_step_start - X;

% PID internals over the plot window
%   PIDA_* = throttle/speed PID, PIDS_* = steering/yaw-rate PID
if experiment == "speed"
    pidPrefix   = "PIDA";
    paramPrefix = "ATC_SPEED";
    chanStr     = "Speed";
    unitStr     = "m/s";
    rcouChan    = "RCOU_C3";
    ctrlLabel   = "RCOU\_C3 (throttle ESC, norm.)";
    mask_pid = t_pida >= t_plot_start & t_pida <= t_step_end;
    t_pid    = t_pida(mask_pid) - t_step_start;
    pid_tar  = d.PIDA_Tar(mask_pid);
    pid_act  = d.PIDA_Act(mask_pid);
    pid_P    = d.PIDA_P(mask_pid);
    pid_I    = d.PIDA_I(mask_pid);
    pid_D    = d.PIDA_D(mask_pid);
    pid_FF   = d.PIDA_FF(mask_pid);
else  % "yaw"
    pidPrefix   = "PIDS";
    paramPrefix = "ATC_STR_RAT";
    chanStr     = "Yaw rate";
    unitStr     = "rad/s";
    rcouChan    = "RCOU_C1";
    ctrlLabel   = "RCOU\_C1 (rudder, norm.)";
    mask_pid = t_pids >= t_plot_start & t_pids <= t_step_end;
    t_pid    = t_pids(mask_pid) - t_step_start;
    pid_tar  = d.PIDS_Tar(mask_pid);
    pid_act  = d.PIDS_Act(mask_pid);
    pid_P    = d.PIDS_P(mask_pid);
    pid_I    = d.PIDS_I(mask_pid);
    pid_D    = d.PIDS_D(mask_pid);
    pid_FF   = d.PIDS_FF(mask_pid);
end
pid_out = pid_P + pid_I + pid_D + pid_FF;

% Control effort sent to the actuator (PWM -> normalized [-1, +1])
t_rcou_all = d.RCOU_timestamp - t0;
mask_rcou  = t_rcou_all >= t_plot_start & t_rcou_all <= t_step_end;
t_rcou     = t_rcou_all(mask_rcou) - t_step_start;
ctrl_norm  = normalize_pwm(d.(rcouChan)(mask_rcou), 1500, 1900, 1100);

% Step metrics over the post-onset portion
% (stepinfo signature: stepinfo(y, t, yfinal) -- y first, then t.)
tmask = t_pid >= 0;
S_raw = stepinfo(pid_act(tmask), t_pid(tmask), act_steady_state);

S = struct();
S.RiseTime         = S_raw.RiseTime;
S.SettlingTime     = S_raw.SettlingTime;
S.Overshoot        = S_raw.Overshoot;
S.Peak             = S_raw.Peak;
S.PeakTime         = S_raw.PeakTime;
S.SteadyStateError = tar_amplitude - act_steady_state;

% PID gains from the params struct
P_gain  = d.params.(sprintf("%s_P",  paramPrefix));
I_gain  = d.params.(sprintf("%s_I",  paramPrefix));
D_gain  = d.params.(sprintf("%s_D",  paramPrefix));
FF_gain = d.params.(sprintf("%s_FF", paramPrefix));

clf();

% (211) Tar / Act with reference lines and a legend-style metrics text box
ax1 = subplot(2,1,1);
hold on;
plot(t_pid, pid_tar, "DisplayName", sprintf("%s\\_Tar", pidPrefix));
plot(t_pid, pid_act,  "DisplayName", sprintf("%s\\_Act", pidPrefix));
xline(ax1, 0, ":", "DisplayName", "Step Onset", ...
    "LabelVerticalAlignment", "bottom", "LabelHorizontalAlignment", "center");
yline(ax1, act_steady_state, ":", "DisplayName", "Act(ual) Steady State");
yline(ax1, tar_amplitude,    ":", "DisplayName", "Tar(get) Amplitude");
hold off;
ylabel(sprintf("%s (%s)", chanStr, unitStr));
title(sprintf("%s PID Internals - Step Window", chanStr), "Interpreter", "none");
l1 = legend("Location", "northeast","FontSize",textbox_fontsize);
grid on;

metrics_text = sprintf([ ...
    'Step Response Metrics\n' ...
    '  Rise time          :%10.3f s    \n' ...
    '  Settling time      :%10.3f s    \n' ...
    '  Overshoot          :%10.3f pct  \n' ...
    '  Peak               :%10.3f %s  \n' ...
    '  Peak time          :%10.3f s    \n' ...
    '  Steady-state error :%10.3f %s  '], ...
    S.RiseTime, S.SettlingTime, S.Overshoot, ...
    S.Peak, unitStr, S.PeakTime, ...
    S.SteadyStateError, unitStr);
text(ax1, 0.98, 0.05, metrics_text, ...
    "Units", "normalized", ...
    "HorizontalAlignment", "right", ...
    "VerticalAlignment", "bottom", ...
    "FontName", "FixedWidth", "FontSize", textbox_fontsize, ...
    "BackgroundColor", "white", "EdgeColor", "black", "Margin", 4);

% (212) Term breakdown with a legend-style PID-gains text box
ax2 = subplot(2,1,2);
hold on;
plot(t_pid,  pid_P,       "DisplayName", sprintf("%s\\_P",          pidPrefix));
plot(t_pid,  pid_I,       "DisplayName", sprintf("%s\\_I",          pidPrefix));
plot(t_pid,  pid_D,       "DisplayName", sprintf("%s\\_D",          pidPrefix));
plot(t_pid,  pid_FF,      "DisplayName", sprintf("%s\\_FF",         pidPrefix));
plot(t_pid,  pid_out,    "DisplayName", sprintf("%s\\_(P+I+D+FF)", pidPrefix));
plot(t_rcou, ctrl_norm, "--",  "DisplayName", ctrlLabel);
hold off;
ylabel("PID Contributions");
xlabel("Time (s) - relative to step onset");
l2 = legend("Location", "northeast","FontSize",textbox_fontsize);
grid on;

gains_text = sprintf([ ...
    'PID Gains (%s_*)\n' ...
    'P :\t %.2f\n' ...
    'I :\t %.2f\n' ...
    'D :\t %.2f\n' ...
    'FF:\t %.2f'], ...
    paramPrefix, P_gain, I_gain, D_gain, FF_gain);
text(ax2, 0.98, 0.05, gains_text, ...
    "Units", "normalized", ...
    "HorizontalAlignment", "right", ...
    "VerticalAlignment", "bottom", ...
    "FontName", "FixedWidth", "FontSize", textbox_fontsize, ...
    "BackgroundColor", "white", "EdgeColor", "black", "Margin", 4,"Interpreter","none");

linkaxes([ax1, ax2], "x");

%% Local functions
function out = normalize_pwm(pwm, inzero, inmax, inmin)
% NORMALIZE_PWM  Scale ArduPilot PWM (1000-2000) to normalized effort (-1..+1).
%   Piecewise linear so asymmetric PWM ranges still map to +/-1 at the
%   endpoints: inzero -> 0, inmax -> +1, inmin -> -1.
out = zeros(size(pwm));
pos = pwm >= inzero;
out( pos) = (pwm( pos) - inzero) / (inmax - inzero);
out(~pos) = (pwm(~pos) - inzero) / (inzero - inmin);
end
