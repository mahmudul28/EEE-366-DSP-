clc;
clear;
close all;

n = -10:10;

%% ==========================================================
% Task-01
% ==========================================================

subplot(4,1,1)
x = 0.5*sin(pi*n/4);
stem(n,x,'filled','m')
grid on
xlabel('n')
ylabel('Amplitude')
title('Discrete Sinusoidal Signal')

subplot(4,1,2)
x = (n==0);
stem(n,x,'filled','g')
grid on
xlabel('n')
ylabel('Amplitude')
title('Unit Impulse Signal')

subplot(4,1,3)
x = (n>=0);
stem(n,x,'filled','b')
grid on
xlabel('n')
ylabel('Amplitude')
title('Unit Step Signal')

subplot(4,1,4)
x = n.*(n>=0);
stem(n,x,'filled','r')
grid on
xlabel('n')
ylabel('Amplitude')
title('Ramp Signal')


%% ==========================================================
% SYSTEM RESPONSE, CONVOLUTION & CORRELATION
% ==========================================================

figure

%% Impulse Response

subplot(3,2,1)

x_imp = (n==0);
h = filter([0.5 1.5],[1 1],x_imp);

stem(n,h,'filled','g')
grid on
xlabel('n')
ylabel('Amplitude')
title('Impulse Response')

%% Step Response

subplot(3,2,2)

x_step = (n>=0);
y_step = filter([0.5 1.5],[1 1],x_step);

stem(n,y_step,'filled','b')
grid on
xlabel('n')
ylabel('Amplitude')
title('Step Response')

%% Convolution

subplot(3,2,3)

y_conv = conv(x_step,h);

stem(y_conv,'filled','r')
grid on
xlabel('n')
ylabel('Amplitude')
title('Convolution: u(n) * h(n)')

%% Filter Output

subplot(3,2,4)

stem(y_step,'filled','m')
grid on
xlabel('n')
ylabel('Amplitude')
title('Filter Output')


%% Cross Correlation

subplot(3,2,5)

r = xcorr(y_step,y_conv);

stem(r,'filled','k')
grid on
xlabel('Lag')
ylabel('Correlation')
title('Cross Correlation')