clearvars
close all
load greasy.mat
s=s';

Fs = 16000;
To = 1/Fs;
L=size(s,2);

t=0:To:(L-1)/Fs;

figure


f = 0:0.001:1;
z = exp(2*pi*f*1i);
haar= 1/sqrt(2)*(1+z.^(-1));

subplot(2,1,1)
plot(f,abs(haar));


subplot(2,1,2)
b0 = 0.05634;
b1 = [1  1];
b2 = [1 -1.0166 1];
a1 = [1 -0.683];
a2 = [1 -1.4461 0.7957];

b = b0*conv(b1,b2);
a = conv(a1,a2);

h0=1/sqrt(2)*[+1 +1];
[h,w] = freqz(h0,2001);

plot(w/pi,20*log10(abs(h)))
plot(w, abs(h))
ax = gca;
ax.YLim = [-100 20];
ax.XTick = 0:.5:2;
xlabel('Normalized Frequency (\times\pi rad/sample)')
ylabel('Magnitude (dB)')
[h,w] = freqz(b,a,'whole',2001);