clc;
clear;
close all;


%% Task 1: Convolution in Z-Domain

% X1(z) = 1 + 2z^-1 + 5z^-2   -> coefficients in ascending powers of z^-1
% X2(z) = 1 - 3z^-1 + 4z^-2

x1 = [1 2 5];
x2 = [1 -3 4];

y  = conv(x1, x2);

fprintf('========== Task 1: Convolution in Z-Domain ==========\n');
fprintf('X1(z) coefficients (ascending powers of z^-1): ');
disp(x1);
fprintf('X2(z) coefficients (ascending powers of z^-1): ');
disp(x2);
fprintf('Y(z) = X1(z) * X2(z) coefficients: ');
disp(y);

% Print the resulting polynomial in a readable z^-1 form
polyStr = 'Y(z) = ';
for n = 1:length(y)
    coeff = y(n);
    power = n - 1;
    if n > 1
        if coeff >= 0
            polyStr = [polyStr, ' + '];
        else
            polyStr = [polyStr, ' - '];
        end
        coeff = abs(coeff);
    end
    if power == 0
        polyStr = [polyStr, sprintf('%g', coeff)];
    else
        polyStr = [polyStr, sprintf('%g*z^-%d', coeff, power)];
    end
end
fprintf('%s\n\n', polyStr);

% Manual verification (expansion) for cross-check, printed to Command Window
% (1 + 2z^-1 + 5z^-2)(1 - 3z^-1 + 4z^-2)
% z^0 : 1*1                     = 1
% z^-1: 1*(-3) + 2*1             = -1
% z^-2: 1*4 + 2*(-3) + 5*1       = 3
% z^-3: 2*4 + 5*(-3)             = -7
% z^-4: 5*4                      = 20
fprintf('Manual expansion check (should match conv result above):\n');
fprintf('[1  -1  3  -7  20]\n\n');

% Figure 1: visualize the coefficient sequences and the convolution result
figure('Name','Task 1 Figure');
subplot(3,1,1);
stem(0:length(x1)-1, x1, 'filled','LineWidth',1.2);
grid on;
xlabel('n (power of z^{-1})'); ylabel('Amplitude');
title('Coefficients of X_1(z)');

subplot(3,1,2);
stem(0:length(x2)-1, x2, 'filled','LineWidth',1.2,'Color','r');
grid on;
xlabel('n (power of z^{-1})'); ylabel('Amplitude');
title('Coefficients of X_2(z)');

subplot(3,1,3);
stem(0:length(y)-1, y, 'filled','LineWidth',1.2,'Color',[0 0.6 0]);
grid on;
xlabel('n (power of z^{-1})'); ylabel('Amplitude');
title('Convolution Result: Coefficients of Y(z) = X_1(z) X_2(z)');

sgtitle('Task 1: Convolution in Z-Domain');


%% Task 2: Residues, Poles, and Inverse Z-Transform

% H(z) = (z^2 - 4z + 6) / (z^2 - 3z + 2)


b = [1 -4 6];   % numerator coefficients:   1, -4z^-1, 6z^-2
a = [1 -3 2];   % denominator coefficients: 1, -3z^-1, 2z^-2

% residuez requires the Signal Processing Toolbox.
[r, p, k] = residuez(b, a);

fprintf('========== Task 2: Residues, Poles, and Inverse Z-Transform ==========\n');
fprintf('Poles of H(z):\n'); disp(p);
fprintf('Residues of H(z):\n'); disp(r);
fprintf('Direct (polynomial) terms of H(z):\n'); disp(k);

% Since numerator and denominator have the SAME order (both degree 2),
% residuez returns one direct term k, corresponding to a constant
% (k * z^0) added to the strictly-proper partial fraction expansion:
%
%   H(z) = k + r(1)/(1 - p(1)z^-1) + r(2)/(1 - p(2)z^-1)
%
% ASSUMPTION: The system is assumed CAUSAL, i.e. the ROC is
% |z| > max(|poles|). Under this assumption, each term
% r_i / (1 - p_i z^-1) corresponds to the causal sequence
% r_i * (p_i)^n * u[n], and the direct term k contributes k*delta[n].

N = 10;                 % number of samples to display/plot
n = 0:N;
h = zeros(1, length(n));

for idx = 1:length(p)
    h = h + r(idx) * (p(idx) .^ n);
end

if ~isempty(k)
    h(n == 0) = h(n == 0) + k(1);  % direct term adds an impulse at n = 0
end

fprintf('\nInverse Z-transform (causal assumption, ROC: |z| > %.4f):\n', max(abs(p)));
fprintf('h[n] = %.4f*delta[n]', k(1));
for idx = 1:length(p)
    fprintf(' + (%.4f)*(%.4f)^n * u[n]', r(idx), p(idx));
end
fprintf('\n\n');

fprintf('h[n] for n = 0..%d:\n', N);
disp(h);
fprintf('\n');

% Figure 2: time-domain sequence h[n]
figure('Name','Task 2 Figure');
stem(n, h, 'filled', 'LineWidth', 1.2);
grid on;
xlabel('n'); ylabel('h[n]');
title('Task 2: Residues, Poles, and Inverse Z-Transform');


%% Task 3: Pole-Zero Plot and Stability Analysis
% Given expression:
%   H(z) = z^2 - 4z^-2 - 1.8z + 0.8

numCoeffs = [1 -1.8 0.8 0 -4];   % z^4 - 1.8z^3 + 0.8z^2 + 0z - 4
denCoeffs = [1 0 0];             % z^2

zerosH = roots(numCoeffs);
polesH = roots(denCoeffs);

fprintf('========== Task 3: Pole-Zero Plot and Stability Analysis ==========\n');
fprintf('Equivalent rational form: H(z) = (z^4 - 1.8z^3 + 0.8z^2 - 4) / z^2\n\n');
fprintf('Zeros of H(z):\n'); disp(zerosH);
fprintf('Poles of H(z) (double pole at origin):\n'); disp(polesH);

maxPoleMag = max(abs(polesH));
fprintf('Maximum pole magnitude |p|_max = %.4f\n', maxPoleMag);

if maxPoleMag < 1
    stabilityMsg = 'STABLE (all poles lie strictly inside the unit circle).';
elseif maxPoleMag == 1
    stabilityMsg = 'MARGINALLY STABLE (poles lie on the unit circle).';
else
    stabilityMsg = 'UNSTABLE (at least one pole lies outside the unit circle).';
end
fprintf('Stability conclusion: %s\n\n', stabilityMsg);

% Figure 3: pole-zero plot with unit circle
figure('Name','Task 3 Figure');
theta = linspace(0, 2*pi, 500);
plot(cos(theta), sin(theta), 'k--', 'LineWidth', 1.2); % unit circle
hold on;
plot(real(zerosH), imag(zerosH), 'bo', 'MarkerSize', 10, 'LineWidth', 1.5); % zeros
plot(real(polesH), imag(polesH), 'rx', 'MarkerSize', 12, 'LineWidth', 2);   % poles
xline(0, 'Color', [0.7 0.7 0.7]);
yline(0, 'Color', [0.7 0.7 0.7]);
axis equal;
grid on;
xlabel('Real Part'); ylabel('Imaginary Part');
title('Task 3: Pole-Zero Plot and Stability Analysis');
legend('Unit Circle', 'Zeros', 'Poles', 'Location', 'bestoutside');
hold off;


%% Summary of Results

fprintf('========== SUMMARY ==========\n');
fprintf('Task 1: Y(z) coefficients = ');
disp(y);
fprintf('Task 2: Poles = '); disp(p.');
fprintf('        Residues = '); disp(r.');
fprintf('        Direct term(s) = '); disp(k(:).');
fprintf('        h[n] (n=0..%d) computed and plotted assuming a CAUSAL system.\n', N);
fprintf('Task 3: Zeros = '); disp(zerosH.');
fprintf('        Poles = '); disp(polesH.');
fprintf('        Conclusion: %s\n', stabilityMsg);
