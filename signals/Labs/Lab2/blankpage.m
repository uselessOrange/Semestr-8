% Parameters
fs = 1000;                     % Sampling frequency (Hz)
N = 1000;                      % Number of samples
t = (0:N-1)/fs;                % Time vector

% Generate signal y (sum of two sine waves)
f1 = 10; A1 = 1;               % Frequency and amplitude of first sine wave
f2 = 300; A2 = 0.2;            % Frequency and amplitude of second sine wave
y = A1 * sin(2*pi*f1*t) + A2 * sin(2*pi*f2*t);

% Create rectangular window h
M = 21;                        % Length of window
h = ones(1, M) / M;            % Normalized rectangular window

% Perform convolution
y_filtered = conv(y, h, 'full'); 

% Trim to original length
y_filtered = y_filtered(1:N);

% Plot original and filtered signals
figure;
subplot(2,1,1);
plot(t, y, 'b');
xlabel('Time (s)');
ylabel('Amplitude');
title('Original Signal');
grid on;

subplot(2,1,2);
plot(t, y_filtered, 'r');
xlabel('Time (s)');
ylabel('Amplitude');
title('Filtered Signal (Rectangular Window)');
grid on;
%% 

% Parameters
fs = 1000;                     % Sampling frequency (Hz)
N = 1000;                      % Number of samples
t = (0:N-1)/fs;                % Time vector

% Generate signal y (sum of two sine waves)
f1 = 10; A1 = 1;               % Frequency and amplitude of first sine wave
f2 = 300; A2 = 0.2;            % Frequency and amplitude of second sine wave
y = A1 * sin(2*pi*f1*t) + A2 * sin(2*pi*f2*t);

% Create rectangular window filter (low-pass FIR filter)
M = 21;                        % Length of window
h = ones(1, M) / M;            % Normalized rectangular window

% Filtering using filter() (introduces phase shift)
y_filter = filter(h, 1, y);

% Zero-phase filtering using filtfilt()
y_filtfilt = filtfilt(h, 1, y);

% Implementing manual zero-phase filtering (time-reversed filtering)
y_manual = filter(h, 1, y);         % Forward filtering
y_manual = flip(y_manual);          % Time reversal
y_manual = filter(h, 1, y_manual);  % Apply filter again
y_manual = flip(y_manual);          % Reverse again to restore original time order

% Plot comparison in time domain
figure;
subplot(2,1,1);
plot(t, y, 'b', 'LineWidth', 1); hold on;
plot(t, y_filter, 'r', 'LineWidth', 1);
plot(t, y_filtfilt, 'g', 'LineWidth', 1);
plot(t, y_manual, 'm', 'LineWidth', 1);
xlabel('Time (s)');
ylabel('Amplitude');
title('Time-Domain Comparison');
legend('Original Signal', 'Filtered (filter)', 'Zero-Phase (filtfilt)', 'Zero-Phase (Manual)');
grid on; hold off;

% Compute FFT for frequency analysis
Y = abs(fft(y)/N);  
Y_filter = abs(fft(y_filter)/N);
Y_filtfilt = abs(fft(y_filtfilt)/N);
Y_manual = abs(fft(y_manual)/N);
freqs = (0:N-1)*(fs/N);

% Frequency-Domain Comparison
subplot(2,1,2);
plot(freqs(1:N/2), Y(1:N/2), 'b', 'LineWidth', 1); hold on;
plot(freqs(1:N/2), Y_filter(1:N/2), 'r', 'LineWidth', 1);
plot(freqs(1:N/2), Y_filtfilt(1:N/2), 'g', 'LineWidth', 1);
plot(freqs(1:N/2), Y_manual(1:N/2), 'm', 'LineWidth', 1);
xlabel('Frequency (Hz)');
ylabel('Magnitude');
title('Frequency-Domain Comparison');
legend('Original Signal', 'Filtered (filter)', 'Zero-Phase (filtfilt)', 'Zero-Phase (Manual)');
grid on; hold off;
%% 

% Sampling Frequency
fs = 1000;

% Define different window lengths
M1 = 11;
M2 = 21;
M3 = 51;

% Define rectangular window filters (normalized)
h1 = ones(1, M1) / M1; % Window length = 11
h2 = ones(1, M2) / M2; % Window length = 21
h3 = ones(1, M3) / M3; % Window length = 51

% Frequency response of filters
figure;
subplot(3,1,1);
freqz(h1, 1, 1024, fs);
title('Frequency Response - Rectangular Window (M = 11)');

subplot(3,1,2);
freqz(h2, 1, 1024, fs);
title('Frequency Response - Rectangular Window (M = 21)');

subplot(3,1,3);
freqz(h3, 1, 1024, fs);
title('Frequency Response - Rectangular Window (M = 51)');



