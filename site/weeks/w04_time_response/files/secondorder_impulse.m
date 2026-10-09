%[text] # Second-Order Model: Transfer Function and Impulse Response
%[text] We derive the impulse response of a canonical underdamped second-order model by hand, then verify the result by overlaying the analytical solution on MATLAB's `impulse()` response.
%%
%[text] ## Analytical solution to the impulse response
%[text] We consider one of the canonical forms of an underdamped second-order transfer function
%[text] $G(s) = K\_{dc} \\frac{\\omega\_n^2}{(s+\\zeta \\omega\_n)^2 + \\omega\_d^2}$
%[text] where $\\zeta \\omega\_n$ is the real part of the complex poles and $\\omega\_d$ is the imaginary part of the complex poles.
%[text] We write it in this form so that the DC gain of the system is $K\_{dc}$. To see this, recall that $\\omega\_d = \\omega\_n \\sqrt{1-\\zeta^2}$, so $(\\zeta \\omega\_n)^2 + \\omega\_d^2 = \\omega\_n^2$ and
%[text] $\\lim\_{s \\rightarrow 0} G(s) = K\_{dc} \\frac{\\omega\_n^2}{(\\zeta \\omega\_n)^2 + \\omega\_d^2} = K\_{dc}$
%[text] The impulse response of this model is the inverse Laplace transform of the transfer function,
%[text] $c(t) = \\mathcal{L}^{-1} \[ G(s) \]$
%[text] We use the Laplace transform pair
%[text] $\\mathcal{L} \\left\[ e^{-at} \\sin(bt) \\right\] = \\frac{b}{(s+a)^2 + b^2}$
%[text] with $a = \\zeta \\omega\_n$ and $b = \\omega\_d$. Factoring $G(s)$ so that the numerator matches the pair,
%[text] $c(t) = \\mathcal{L}^{-1} \\left\[ K\_{dc} \\left( \\frac{\\omega\_n^2}{\\omega\_d} \\right) \\frac{\\omega\_d}{(s+\\zeta \\omega\_n)^2 + \\omega\_d^2} \\right\] = K\_{dc} \\left( \\frac{\\omega\_n^2}{\\omega\_d} \\right) e^{-\\zeta \\omega\_n t} \\sin(\\omega\_d t)$
%[text] or, written in terms of the real and imaginary parts of the poles,
%[text] $c(t) = K\_{dc} \\left( \\frac{(\\zeta \\omega\_n)^2 + \\omega\_d^2}{\\omega\_d} \\right) e^{-\\zeta \\omega\_n t} \\sin(\\omega\_d t)$
%[text] The constant can be simplified further using the relations $\\omega\_d = \\omega\_n \\sqrt{1-\\zeta^2}$ and $\\omega\_n^2 = (\\zeta \\omega\_n)^2 + \\omega\_d^2$, which give two more equivalent forms:
%[text] $c(t) = K\_{dc} \\left( \\frac{\\omega\_n}{\\sqrt{1-\\zeta^2}} \\right) e^{-\\zeta \\omega\_n t} \\sin(\\omega\_d t)$
%[text] $c(t) = K\_{dc} \\left( \\frac{\\sqrt{(\\zeta \\omega\_n)^2 + \\omega\_d^2}}{\\sqrt{1-\\zeta^2}} \\right) e^{-\\zeta \\omega\_n t} \\sin(\\omega\_d t)$
%[text] **Example.** Consider the system with $\\zeta \\omega\_n = 0.5$ and $\\omega\_d = 2\\pi$ rad/s, modeled by the transfer function
%[text] $G(s) = K\_{dc} \\frac{0.5^2 + (2\\pi)^2}{(s+0.5)^2 + (2\\pi)^2}$
%[text] which has the impulse response
%[text] $c(t) = K\_{dc} \\left( \\frac{0.5^2 + (2\\pi)^2}{2\\pi} \\right) e^{-0.5\\,t} \\sin(2\\pi\\,t)$
%%
%[text] ## Verify with MATLAB
%[text] Build the example transfer function from the pole parameters. The real part of the pole pair is $\\zeta \\omega\_n$, the imaginary part is $\\omega\_d$, and we take $K\_{dc} = 1$.
zwn = 0.5;      % zeta*omega_n, real part of the poles
wd  = 2*pi;     % omega_d, imaginary part of the poles (rad/s)
Kdc = 1;        % DC gain
%[text] The denominator $(s+\\zeta \\omega\_n)^2 + \\omega\_d^2$ expands to $s^2 + 2\\zeta \\omega\_n s + (\\zeta \\omega\_n)^2 + \\omega\_d^2$. We build it with `conv()` for the squared term and add $\\omega\_d^2$ to the constant coefficient.
num = Kdc*(zwn^2 + wd^2);
den = conv([1 zwn], [1 zwn]) + [0 0 wd^2];
G = tf(num, den)
%[text] Check that the DC gain is $K\_{dc}$, as designed.
dcgain(G)
%%
%[text] Plot MATLAB's impulse response, then overlay the analytical solution on the same time vector.
[c_matlab, tt] = impulse(G);
c_analytic = Kdc*(zwn^2 + wd^2)/wd * exp(-zwn*tt) .* sin(wd*tt);

figure(1)
clf()
plot(tt, c_matlab, 'b-')
hold on
plot(tt, c_analytic, 'r--')
hold off
grid on
xlabel('Time (s)')
ylabel('c(t)')
title('Impulse response: MATLAB impulse() vs. analytical solution')
legend('MATLAB impulse()', 'Analytical solution', 'Location', 'northeast')
%[text] The two curves lie on top of each other. 
max(abs(c_matlab - c_analytic))

%[appendix]{"version":"1.0"}
%---
%[metadata:view]
%   data: {"layout":"inline"}
%---
