
% Request to demo ltivew app
Ga = tf(16, [1 3 16]);
Gb = tf(0.04, [1 0.02 0.04]);
Gc = tf(1.05e7, [1 1.6e3 1.05e7]);

ltiview('step', Ga)

% Vice
stepinfo(Ga)
damp(Ga)