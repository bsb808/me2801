%[text] # ME 2801, HW2, Inverse Laplace Transform
%[text] Partial fraction expansion with complex roots.   
%[text] $F(s) = \\frac{s+5}{(s+2)(s^2+36)}$
%[text] Using the handout on Partial Fraction Expansion with Complex Roots
num = [1 5];
den = conv([1 2],[1 0 36]) %[output:9dde78ae]
[R1,P1,K1] = residue(num,den) %[output:9f5ed85b] %[output:5d83183b] %[output:4e6e8558]
%[text]{"align":"center"} $ a= 0, \\, \\omega = 6 , \\, \\alpha = -0.0375, \\, \\beta = 0.0958 $
%[text]{"align":"center"} $ F(s) = \\frac{2( -0.0375) s}{s^2 + 6^2} + \\frac{2(0.0958)(6)}{s^2 + 6^2} + \\frac{0.075}{s+2}$
%[text]{"align":"center"} $ f(t) = 2 \[ -0.0375 cos(6t) + 0.0958 sin(6t) \] + 0.075 e^{-2t} $
%[text] ## G(s)
%[text] $G(s) = \\frac{2}{s\\,(s^2+s+16.25)}$
num = 2;
den = [1 1 16.25 0];
[R2,P2,K2] = residue(num,den) %[output:2237f028] %[output:03dad852] %[output:3ac1937a]
%[text]{"align":"center"} $ a= 0.5, \\, \\omega = 4 , \\, \\alpha = -0.0615, \\, \\beta = -0.0077 $
%[text]{"align":"center"} $ G(s) = 2 \\left\[ \\frac{-0.0615 (s+0.5) - 0.0077 (4)}{(s+0.5)^2+4^2}\n\\right\] + \\frac{0.1231}{s} $
%[text]{"align":"center"} $ g(t) = 2 e^{-0.5 t}\\left\[ -0.0615 cos(4t) - 0.0077 sin(4t)\\right\] +\n0.1231 $
%[text] ## H(s)
%[text] $H(s) = \\frac{1}{(s^2+9)(s^2+4s+1)}$
num = 1;
den = conv([1 0 9],[1 4 1]);
[R3,P3,K3] = residue(num,den) %[output:013dbff0] %[output:679e074d] %[output:782c555c]
%%
%[text]{"align":"center"} $ a= 0, \\, \\omega = 3 , \\, \\alpha = -0.0096, \\, \\beta = -0.0064 $
%[text]{"align":"center"} $ H(s) = 2 \\left\[ \\frac{-0.0096 (s) - 0.0064 (3)}{s^2+3^2}\n\\right\] + \\frac{-0.0126}{s+3.7321} + \\frac{0.0318}{s+0.2679} $
%[text]{"align":"center"} $ g(t) = 2 \\left\[ -0.096 cos(3t) - 0.0064 sin(3t)\\right\] - 0.0126 e^{-3.7321 t} + 0.0318 e^{-0.2679 t} $

%[appendix]{"version":"1.0"}
%---
%[metadata:view]
%   data: {"layout":"inline","rightPanelPercent":40}
%---
%[output:9dde78ae]
%   data: {"dataType":"matrix","outputData":{"columns":4,"name":"den","rows":1,"type":"double","value":[["1","2","36","72"]]}}
%---
%[output:9f5ed85b]
%   data: {"dataType":"matrix","outputData":{"columns":1,"name":"R1","rows":3,"type":"complex","value":[["-0.0375 - 0.0958i"],["-0.0375 + 0.0958i"],["0.0750 + 0.0000i"]]}}
%---
%[output:5d83183b]
%   data: {"dataType":"matrix","outputData":{"columns":1,"name":"P1","rows":3,"type":"complex","value":[["0.0000 + 6.0000i"],["0.0000 - 6.0000i"],["-2.0000 + 0.0000i"]]}}
%---
%[output:4e6e8558]
%   data: {"dataType":"text","outputData":{"text":"\nK1 =\n\n     []\n\n","truncated":false}}
%---
%[output:2237f028]
%   data: {"dataType":"matrix","outputData":{"columns":1,"name":"R2","rows":3,"type":"complex","value":[["-0.0615 + 0.0077i"],["-0.0615 - 0.0077i"],["0.1231 + 0.0000i"]]}}
%---
%[output:03dad852]
%   data: {"dataType":"matrix","outputData":{"columns":1,"name":"P2","rows":3,"type":"complex","value":[["-0.5000 + 4.0000i"],["-0.5000 - 4.0000i"],["0.0000 + 0.0000i"]]}}
%---
%[output:3ac1937a]
%   data: {"dataType":"text","outputData":{"text":"\nK2 =\n\n     []\n\n","truncated":false}}
%---
%[output:013dbff0]
%   data: {"dataType":"matrix","outputData":{"columns":1,"name":"R3","rows":4,"type":"complex","value":[["-0.0126 + 0.0000i"],["-0.0096 + 0.0064i"],["-0.0096 - 0.0064i"],["0.0318 + 0.0000i"]]}}
%---
%[output:679e074d]
%   data: {"dataType":"matrix","outputData":{"columns":1,"name":"P3","rows":4,"type":"complex","value":[["-3.7321 + 0.0000i"],["0.0000 + 3.0000i"],["0.0000 - 3.0000i"],["-0.2679 + 0.0000i"]]}}
%---
%[output:782c555c]
%   data: {"dataType":"text","outputData":{"text":"\nK3 =\n\n     []\n\n","truncated":false}}
%---
