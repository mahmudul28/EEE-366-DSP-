% Lab Exercise 1: System Responses
clear; clc; close all;

n = -10:20;
u = [zeros(1, 10), ones(1, 21)]; 
impulse = [zeros(1, 10), 1, zeros(1, 20)]; 
x_sin = 0.5 * sin(n) .* u;
b = 1;
a = [1, 0.6];
h = filter(b, a, impulse);
y_step_filt = filter(b, a, u);
y_sin_filt = filter(b, a, x_sin);
kmin = n(1) + n(1); 
kmax = n(end) + n(end);
k = kmin:kmax;
y_step_conv = conv(u, h);
y_sin_conv = conv(x_sin, h);

fig1 = figure; 
subplot(3, 2, 1);
stem(n, h, 'filled', 'MarkerSize', 4, 'Color', 'b');
title('Impulse Response h[n]');
xlabel('n'); ylabel('Amplitude');
xlim([-10 20]);
subplot(3, 2, 2);
stem(n, x_sin, 'filled', 'MarkerSize', 4, 'Color', [0.4 0.4 0.4]);
title('Input Signal x_{sin}[n]');
xlabel('n'); ylabel('Amplitude');
xlim([-10 20]);
subplot(3, 2, 3);
stem(n, y_step_filt, 'filled', 'MarkerSize', 4, 'Color', 'b');
title('Step Response (via filter)');
xlabel('n'); ylabel('Amplitude');
xlim([-10 20]);
subplot(3, 2, 4);
stem(k, y_step_conv, 'filled', 'MarkerSize', 4, 'Color', 'r');
title('Step Response (via conv)');
xlabel('n'); ylabel('Amplitude');
xlim([-10 20]); 
subplot(3, 2, 5);
stem(n, y_sin_filt, 'filled', 'MarkerSize', 4, 'Color', 'b');
title('Sinusoidal Response (via filter)');
xlabel('n'); ylabel('Amplitude');
xlim([-10 20]);
subplot(3, 2, 6);
stem(k, y_sin_conv, 'filled', 'MarkerSize', 4, 'Color', 'r');
title('Sinusoidal Response (via conv)');
xlabel('n'); ylabel('Amplitude');
xlim([-10 20]); 
saveas(fig1, 'fig_01.png');

% Post-Lab Work 1 & 2: Autocorrelation of Sine Waves
T = 4e-3;
tstep = T / 100;
t1 = tstep : tstep : T;
x1 = 2 * cos(2 * pi * t1 / T);
[rxx1, lags1] = xcorr(x1);
t2 = tstep : tstep : 4*T;
x2 = 2 * cos(2 * pi * t2 / T);
[rxx2, lags2] = xcorr(x2);

fig2 = figure;
subplot(2, 1, 1);
plot(lags1 * tstep, rxx1, 'LineWidth', 1.2);
title('Autocorrelation of 1 Period');
xlabel('Time Lag (s)'); ylabel('R_{xx}');
grid on;
subplot(2, 1, 2);
plot(lags2 * tstep, rxx2, 'LineWidth', 1.2);
title('Autocorrelation of 4 Periods');
xlabel('Time Lag (s)'); ylabel('R_{xx}');
grid on;
saveas(fig2, 'fig_02.png');

% Post-Lab Work 3: Autocorrelation of White Noise
N_samples = 500;
noise = randn(1, N_samples);
[rxx_noise, lags_noise] = xcorr(noise);

fig3 = figure;
plot(lags_noise, rxx_noise, 'r', 'LineWidth', 1.2);
title('Autocorrelation of Random White Noise');
xlabel('Lag Index'); ylabel('R_{xx}');
grid on;
saveas(fig3, 'fig_03.png');

% Post-Lab Work 4: Radar Target Detection
n_rad = 0:1300;
tx_burst = sin(0.2 * pi * (0:100));
tx_signal = [tx_burst, zeros(1, length(n_rad) - length(tx_burst))];
delay = 450;
echo_weak = 0.1 * tx_burst;
rx_clean = [zeros(1, delay), echo_weak, zeros(1, length(n_rad) - delay - length(echo_weak))];
noise_lvl = 0.5;
rx_noisy = rx_clean + noise_lvl * randn(1, length(n_rad));
[rxy, lags_xy] = xcorr(rx_noisy, tx_signal);

fig4 = figure; 
subplot(4, 1, 1);
plot(n_rad, tx_signal);
title('(a) Transmitted Tone Burst');
xlim([0 1300]);
subplot(4, 1, 2);
plot(n_rad, rx_clean);
title('(b) Weak Echo');
xlim([0 1300]);
subplot(4, 1, 3);
plot(n_rad, rx_noisy, 'Color', [0.7 0.7 0.9]);
title('(c) Echo Masked by Noise');
xlim([0 1300]);
subplot(4, 1, 4);
plot(lags_xy, rxy, 'k');
title('(d) Cross-Correlation Detection');
xlim([0 1300]);
saveas(fig4, 'fig_04.png');