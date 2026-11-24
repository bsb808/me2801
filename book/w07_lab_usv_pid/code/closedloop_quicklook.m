% Quick Look at a Lab 2 Log - check that the data is good
%
% Plots only the channels the Lab 2 analysis needs, so you can confirm a
% log captured a clean step before running closedloop_assess_example.m:
%   PIDA_Tar / PIDA_Act   speed setpoint and measured speed (m/s)
%   PIDS_Tar / PIDS_Act   yaw-rate setpoint and measured yaw rate (rad/s)
%   RCOU_C1 / RCOU_C3     rudder and throttle PWM sent to the actuators

clear;
close("all");

% You will need to change this data file name.
fname = "./closedloop_assess_example.mat";

%% Load the log
d = load(fname);
[~, name, ext] = fileparts(fname);

%% Check that every channel needed for the analysis is present
needed = ["PIDA_timestamp", "PIDA_Tar", "PIDA_Act", ...
          "PIDS_timestamp", "PIDS_Tar", "PIDS_Act", ...
          "RCOU_timestamp", "RCOU_C1",  "RCOU_C3", "params"];
missing = needed(~isfield(d, needed));
if isempty(missing)
    fprintf("All needed channels present.\n");
else
    warning("Missing channels: %s", strjoin(missing, ", "));
end

%% Print the UTC start time and duration - compare with the scribe notes
t0 = min([d.PIDA_timestamp(1), d.PIDS_timestamp(1)]);
t_end = max([d.PIDA_timestamp(end), d.PIDS_timestamp(end)]);
fprintf("Log start (UTC): %s\n", ...
    datetime(t0, "ConvertFrom", "posixtime", "TimeZone", "UTC", ...
             "Format", "yyyy-MM-dd HH:mm:ss"));
fprintf("Duration: %.1f s\n", t_end - t0);

%% Plot the channels against elapsed time
figure(1);
clf();

ax1 = subplot(3,1,1);
plot(d.PIDA_timestamp - t0, d.PIDA_Tar, "b--", "DisplayName", "PIDA\_Tar (setpoint)");
hold on;
plot(d.PIDA_timestamp - t0, d.PIDA_Act, "r-",  "DisplayName", "PIDA\_Act (actual)");
hold off;
ylabel("Speed (m/s)");
title(sprintf("Quick look <%s>", name + ext), "Interpreter", "none");
legend("Location", "best");
grid on;

ax2 = subplot(3,1,2);
plot(d.PIDS_timestamp - t0, d.PIDS_Tar, "b--", "DisplayName", "PIDS\_Tar (setpoint)");
hold on;
plot(d.PIDS_timestamp - t0, d.PIDS_Act, "r-",  "DisplayName", "PIDS\_Act (actual)");
hold off;
ylabel("Yaw rate (rad/s)");
legend("Location", "best");
grid on;

ax3 = subplot(3,1,3);
plot(d.RCOU_timestamp - t0, d.RCOU_C1, "DisplayName", "RCOU\_C1 (rudder)");
hold on;
plot(d.RCOU_timestamp - t0, d.RCOU_C3, "DisplayName", "RCOU\_C3 (throttle)");
hold off;
ylabel("PWM (\mus)");
xlabel("Elapsed time (s)");
legend("Location", "best");
grid on;

linkaxes([ax1, ax2, ax3], "x");
