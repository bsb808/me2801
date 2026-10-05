%[text] # Transfer Function Representation in MATLAB
%[text] Two ways to build the same transfer function object:
%[text] 1.  `zpk()` from the ratio of factors
%[text] 2.  `tf()` from the ratio of polynomials.  \
%[text] Converting one form to the other checks that both describe the same system.
%[text] $G(s) = \\frac{3}{s^3 + 9s^2 + 20s} = \\frac{3}{s(s+4)(s+5)}$
%[text] Ratio of factors: zeros, poles, gain.
Gz = zpk([], [0 -4 -5], 3)
%[text] Ratio of polynomials: coefficient vectors in descending powers of $s$.
Gt = tf(3, [1 9 20 0])
%[text] Check by converting one form to the other.
tf(Gz)
%%
%[text] 
%[text] $H(s) = \\frac{10(s+2)}{s^2(s+4)(s+5)}$
Hz = zpk(-2, [0 0 -4 -5], 10)
%[text] The denominator is a product of factors.  `conv()` multiplies two polynomials.
den = conv([1 0 0], conv([1 4], [1 5]))
Ht = tf(10*[1 2], den)
%[text] Check.
zpk(Ht)

%[appendix]{"version":"1.0"}
%---
%[metadata:view]
%   data: {"layout":"inline"}
%---
