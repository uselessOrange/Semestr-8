% CTW computation using convolution method
clear;
clc;
N = 300;                    % Number of sample points
t = linspace(0, 30, N);     % Time vector
% Signal
x = 5*sin(2*pi*1000*t);      % Signal with frequency of 0.5 Hz
% Continuous wavelet transform parameters
fc = 1;                     % Center frequency of the wavelet
fb = 15;                    % Bandwidth of the wavelet
% Define the Morlet wavelet function
psi = @(t, s) (pi*fb)^(-0.5) * exp(2*1i*pi*fc*t/s) .* exp(-t.^2/(2*fb^2));
% Scale vector
scales = 1:60;
% Initialize CTW coefficients
cwt_coeffs = zeros(N, length(scales));
% Compute CTW using convolution
for si = 1:length(scales)
    s = scales(si);
    % Generate scaled and translated wavelet
    scaled_wavelet = psi(t, s);
    % Compute convolution of x(t) with scaled_wavelet
    cwt_coeffs(:, si) = conv(x, scaled_wavelet, 'same');
end
% Plot the CTW coefficients
figure;
contourf(t, scales, abs(cwt_coeffs'), 'LineStyle', 'none');
colorbar;
xlabel('Time');
ylabel('Scale');
title('Continuous Time Wavelet Transform (CTW)');
cwt(x)