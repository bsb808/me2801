%% USV Lab 1 Data Check
% Confirms that a converted log (.BIN.mat from bin2mat.py) holds the channels
% needed for Lab 1, and plots the whole log so you can find each step test and
% judge whether it is clean.
%   RCOU_C3  — throttle command (PWM)   surge input
%   GPS_Spd  — ground speed (m/s)       surge output
%   RCOU_C1  — rudder command (PWM)     yaw input
%   IMU_GyrZ — yaw rate (rad/s)         yaw output
%   MODE     — flight mode (Lab 1 stays in MANUAL = 0)

clear;

% ── Load CHANGE TO TARGET MAT FILE! ─────────────────────────────────────────
fname = "/data/Downloads/logs/LOGS/00000020.BIN_20260429_201838.mat";

fprintf('Loading %s...\n', fname);
d = load(fname);

[dirpath, name, ext] = fileparts(fname);
[~, lastDir] = fileparts(dirpath);
lastTwo = fullfile(lastDir, name + ext);

%% ── Check that each channel exists ─────────────────────────────────────────
fields = ["RCOU_C3", "GPS_Spd", "RCOU_C1", "IMU_GyrZ", "MODE_ModeNum"];
for f = fields
    if isfield(d, f)
        fprintf('%-13s %7d samples\n', f, numel(d.(f)));
    else
        fprintf('%-13s MISSING\n', f);
    end
end

% Time zero = first actuator output sample
t0 = d.RCOU_timestamp(1);

%% ── Flight-mode changes ────────────────────────────────────────────────────
% ArduRover mode numbers: 0 MANUAL, 1 ACRO, 4 HOLD, 10 AUTO
fprintf('\nMode changes:\n');
for i = 1:numel(d.MODE_timestamp)
    fprintf('  t = %7.1f s   mode %d\n', d.MODE_timestamp(i) - t0, d.MODE_ModeNum(i));
end

%% ── Plot the whole log ─────────────────────────────────────────────────────
figure();
clf()
ax1 = subplot(411);
plot(d.RCOU_timestamp - t0, d.RCOU_C3, 'b-');
ylabel('Throttle (PWM)');
grid on;
title(sprintf("Lab 1 Data Check — %s", lastTwo), 'Interpreter', 'none');

ax2 = subplot(412);
plot(d.GPS_timestamp - t0, d.GPS_Spd, 'r-');
ylabel('Speed (m/s)');
grid on;

ax3 = subplot(413);
plot(d.RCOU_timestamp - t0, d.RCOU_C1, 'b-');
ylabel('Rudder (PWM)');
grid on;

ax4 = subplot(414);
plot(d.IMU_timestamp - t0, d.IMU_GyrZ * (180/pi), 'r-');
ylabel('Yaw Rate (deg/s)');
xlabel('Time (s)');
grid on;

linkaxes([ax1, ax2, ax3, ax4], 'x');
