% assignment_solutions.m  --  Laplace Transforms Assignment verification
% ME 2801 -- Introduction to Feedback Control
%
% Run section-by-section (Ctrl+Enter or "Run Section").
% Each section checks the hand-derived answers in assign_laplace_part1_soln.tex,
% using the Symbolic Math Toolbox for Parts 1-3 and the Control System
% Toolbox for Part 4.

syms s t
assume(t >= 0)

%% Part 1 -- Forward Laplace transforms (Problems 1-5)
f1 = {4*exp(-3*t), 2*sin(5*t), 3*cos(2*t), t*exp(-2*t), 5 - 5*exp(-t)};
fprintf('--- Part 1 ---\n')
for k = 1:numel(f1)
    F = simplify(laplace(f1{k}, t, s));
    fprintf('%d. F(s) = %s\n', k, char(F))
end
% Expect: 4/(s+3), 10/(s^2+25), 3s/(s^2+4), 1/(s+2)^2, 5/(s(s+1))

%% Part 2 -- Inverse Laplace transforms (Problems 6-9)
F2 = {3/(s*(s+3)), (s+1)/((s+2)*(s+4)), 2/(s^2+4*s+3), 10/(s*(s^2+4*s+8))};
fprintf('--- Part 2 ---\n')
for k = 1:numel(F2)
    f = simplify(ilaplace(F2{k}, s, t));
    fprintf('%d. f(t) = %s\n', k+5, char(f))
end
% Expect: 1 - e^{-3t};  -e^{-2t}/2 + 3e^{-4t}/2;  e^{-t} - e^{-3t};
%         (5/4)(1 - e^{-2t}(cos 2t + sin 2t))

%% Part 3 -- ODEs with unit-step input, zero ICs (Problems 10-12)
R = 1/s;
C3 = {8*R/(s+4), 6*R/(s^2+5*s+6), 8*R/(s^2+4*s+8)};
fprintf('--- Part 3 ---\n')
for k = 1:numel(C3)
    c = simplify(ilaplace(C3{k}, s, t));
    fprintf('%d. c(t) = %s\n', k+9, char(c))
end
% Expect: 2(1 - e^{-4t});  1 - 3e^{-2t} + 2e^{-3t};
%         1 - e^{-2t}(cos 2t + sin 2t) = 1 - sqrt(2) e^{-2t} cos(2t - pi/4)

% Problem 12: confirm the two forms of c(t) agree
c12a = 1 - exp(-2*t)*(cos(2*t) + sin(2*t));
c12b = 1 - sqrt(2)*exp(-2*t)*cos(2*t - pi/4);
fprintf('12. forms agree: %d\n', isAlways(simplify(c12a - c12b) == 0))

%% Part 4 -- Pole locations and step responses (Problems 13-14)
s = tf('s');
Ga = 1/((s+1)*(s+3));
Gb = 1/(s^2 + 2*s + 5);
Gc = 1/(s*(s+2));
Gd = 1/((s-1)*(s+3));

fprintf('--- Part 4 ---\n')
fprintf('(a) poles: %s\n', mat2str(pole(Ga).', 3))
fprintf('(b) poles: %s\n', mat2str(pole(Gb).', 3))
fprintf('(c) poles: %s\n', mat2str(pole(Gc).', 3))
fprintf('(d) poles: %s\n', mat2str(pole(Gd).', 3))

tt = 0:0.01:6;
figure(1); clf
subplot(2,2,1); step(Ga, tt); title('(a) overdamped')
subplot(2,2,2); step(Gb, tt); title('(b) underdamped')
subplot(2,2,3); step(Gc, tt); title('(c) pole at origin: ramps')
subplot(2,2,4); step(Gd, tt); title('(d) unstable: e^t growth')
