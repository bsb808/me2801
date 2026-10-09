%[text] # ME2801: Time Response with MATALB
%[text] In addition to Nise Appendix B - MATLAB Tutorial
%[text] MATLAB has tools for
%[text] - Representing a transfer function: `tf()`, `zpk()`
%[text] - Finding polynomial roots: `roots()`
%[text] - Plotting the response: `step(), impulse()`
%[text] - Plotting the poles and zeros
%[text] - Finding system metrics: `stepinfo()`, `damp()` \
%[text] First order system model
%[text] Canonical form
%[text] $G\_1( s ) = K\_{DC} \\frac{ a }{ s+a } = K\_{DC} \\frac{ 1 }{ \\tau s + 1 }$
%[text] Form of the step response
%[text] $c(t) = K\_{DC} \\, \\left(1-e^{-t/\\tau} \\, \\right)$
clear
G1 = tf(1, [1 0.05])
%%
%[text] #### What are the poles and zeros?
pp =pole(G1)
zz =zero(G1)
[z, p, k] = zpkdata(G1)
pzmap(G1)
%%
%[text] ####  Identify system parameters
%[text] - Time constant: $\\tau$ \
damp(G1)
%%
%[text] #### Find response metrics
stepinfo(G1)
%%
%[text] #### Plot responses to test signals
step(G1)

impulse(G1)
%%
%[text] ## Second order underdamped system model
%[text] Canonical form
%[text] $G\_2(s) = K\_{DC}\\frac{ \\left( \\mathcal{R}^2 + \\mathcal{I}^2 \\right)}{(s + \\mathcal{R})^2 + \\mathcal{I}^2} = \nK\_{DC} \\frac{\\left( (\\zeta \\omega\_n)^2 + \\omega\_d^2 \\right)}{(s + \\zeta \\omega\_n)^2 + \\omega\_d^2} =\nK\_{DC} \\frac{\\omega\_n^2}{s^2 + 2 \\zeta \\omega\_n s + \\omega\_n^2}$
%[text] Form of the step response
%[text] $ c(t)  =  K\[1-A \\, e^{-\\zeta \\omega\_n \\,t} \\cos(\\omega\_d \\,t - \\phi)\] \\$
% Complex poles
p1=[1 complex(3, 7)];
p2=[1 complex(3, -7)];
% Create a TF
num = 1;
den = conv(p1, p2);
G2 = tf(num, conv(p1,p2))
%%
%[text] #### What are the poles and zeros?
pp = pole(G2)
pr = roots(den)
zz = zero(G2)
zr = roots(num)
[z, p, k] = zpkdata(G2)
p{1}
pzmap(G2)
%%
%[text] ####  Identify system parameters
%[text] - Undamped natural frequency: $\\omega\_n$
%[text] - Damping ratio: $\n\\zeta$
%[text] - Damped natural frequency: $\\omega\_d = \\mathcal{I} = \\sqrt{1-\\zeta^2} \\, \\omega\_n$ \
damp(G2)
%%
%[text] #### Find response metrics
stepinfo(G2)
%%
%[text] #### Plot responses to test signals
step(G2)

impulse(G2)


%[appendix]{"version":"1.0"}
%---
%[metadata:view]
%   data: {"layout":"onright","rightPanelPercent":40}
%---
