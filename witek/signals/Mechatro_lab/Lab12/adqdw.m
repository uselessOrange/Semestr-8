%task4
d0 = load("40Hz.mat")
d1 = load("40Hz_ref.mat");
t_meas = d1.t_meas;
y_meas = d1.y_meas;
fs = 1e6;
t = 0:1/fs:1-1/fs;
y = d0.A;
y_ref = d0.B;

y = bandpass(y,[0.8e5,1.2e5],fs);

% Remove amplitude modulations
y_env = abs(hilbert(y));
y_demod = y ./ y_env;

% Frequency demodulation
dt = 1/fs;
y_diff = diff(y_demod) / dt;
y_env = abs(hilbert(y_diff));
y_env = y_env - mean(y_env);
y_dem = inteFD(y_env, 1/fs);

% Low-pass filtering
y_dem = lowpass(y_dem, 800, fs);

% Clipping the data vector to remove artifacts
y_dem = y_dem(100:end-100); % Adjust the range as needed

% Display waveforms and spectra
figure;
subplot(2, 1, 1);
plot(t_meas, y_meas);
hold on;
plot(t_meas, y_dem);
hold off;
title('Comparison of Reference and Demodulated Signal (Time Domain)');
xlabel('Time (s)');
ylabel('Amplitude');
legend('Reference Signal', 'Demodulated Signal');

subplot(2, 1, 2);
Y_meas = fft(y_meas);
Y_dem = fft(y_dem);

plot(f, abs(Y_meas));
hold on;
plot(f, abs(Y_dem));
hold off;
title('Comparison of Reference and Demodulated Signal (Frequency Domain)');
xlabel('Frequency (Hz)');
ylabel('Magnitude');
legend('Reference Signal', 'Demodulated Signal');

