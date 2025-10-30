
wn = 1.0;
z = 0.4;
K = 10;
G = tf(K*wn^2,[1 2*z*wn wn^2])
H = tf(0.5*wn^2,[1 2*z*wn wn^2])
figure(1)
subplot(1,2,1)
step(G)
grid on
subplot(1,2,2)
step(H)
grid on

%%
f=figure(2)
clf()
h = bodeplot(G);
grid on
magc = get(f,'Children');
axes(magc(3));
annotation('textarrow',[0.4 0.17],[0.6, 0.79],'String','DC Gain = 20 dB', 'FontSize',14)

f=figure(3)
clf()
h = bodeplot(H);
grid on
magc = get(f,'Children');
axes(magc(3));
annotation('textarrow',[0.3 0.16],[0.7, 0.83],'String','DC Gain = -6 dB', 'FontSize',14)

%%
J = tf(100*wn^2,[1 2*z*wn wn^2])
figure(4)
clf()
step(J)
grid on

J = tf(0.01*wn^2,[1 2*z*wn wn^2])

figure(5)
clf()
bode(J)
grid on