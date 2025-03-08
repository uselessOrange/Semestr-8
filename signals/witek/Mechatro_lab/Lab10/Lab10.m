%% Task 1
%Ex. 1.1
%creating the signal
N = 1000;
fs = 1000;
t = (0:N-1)/fs; % time range
f1 = 30;
a1 = 1;
%creating signal
y = a1*sin(2*pi*f1*t);
%calculating hilbert transform of the sine wave
yh = hilbert(y);
%plotting absolute value of the spectrum
figure()
plot(t,abs(yh))
xlabel('time [s]')
ylabel('Amplitude [-]')
title('plot of absolute value of the analytical spectrum')
ylim([0 2])
%comparing real vs imaginary part of the analytical spectrum
figure()
subplot(2,1,1)
plot(t,real(yh))
xlabel('time [s]')
ylabel('Amplitude [-]')
ylim([-1,1])
title('plot of real part of the analytical spectrum')
subplot(2,1,2)
plot(t,imag(yh))
xlabel('time [s]')
ylabel('Amplitude [-]')
ylim([-1,1])
title('plot of imaginary part of the analytical spectrum')
sgtitle('phase shift between real and imaginary parts of the spectrum')
%checking phase shift
figure()
plot(t,real(yh)), hold on
plot(t,imag(yh)), hold off
legend('real','imaginary')
xlabel('time [s]')
ylabel('Amplitude [-]')
ylim([-1,1])
title('plot of real vs imaginary part of the analytical spectrum')
%calculating time shift
dt=0.35-0.342; %[s]
T=1/f1;
dphi1 = 360*dt/T %probably should be 90 deg, but its 97 due to rounding of the dt
%recalculating phase shift ofor a different frequency
f2 = 10;
y2 = a1*sin(2*pi*f2*t);
%calculating hilbert transform of the sine wave
yh2 = hilbert(y2);
%plotting absolute value of the spectrum
%checking phase shift
figure()
plot(t,real(yh2)), hold on
plot(t,imag(yh2)), hold off
legend('real','imaginary')
xlabel('time [s]')
ylabel('Amplitude [-]')
ylim([-1,1])
title('plot of real vs imaginary part of the analytical spectrum no. 2')
%calculating time shift
dt2=0.35-0.325; %[s]
T2=1/f2;
dphi2 = 360*dt2/T2 %probably should be 90 deg, but its 97 due to rounding of the dt


%Ex. 1.2
% Calculating the envelope using Fourier Transform
Y_fft = fft(y2);                % Compute FFT of the signal
H = zeros(size(Y_fft));                          % Initialize a transfer function
H(1:ceil(length(Y_fft)/2)) = 1;                  % Retain only the positive frequency parts
analyticalSignal_fft = Y_fft .* H;               % Apply the transfer function
analyticalSignal = ifft(analyticalSignal_fft) .*2;   % Compute the inverse FFT
envelopesig = abs(analyticalSignal);             % Magnitude gives the envelope

figure()
plot(t,envelopesig)
xlabel('time [s]')
ylabel('Amplitude [-]')
title('Plot of the enveloped signal using FFT')
ylim([0 2])

%% Task 2
F0 = 5;
F1 = 200;
fs = 2000; % sampling frequency
N = 2000; % number of samples
T = (0:N-1)/fs; % time range
T1 = 1;
Y = chirp(T,F0,T1,F1, 'linear');
y = Y.*hann(N)';
%Ex. 2.1
sa = hilbert(y);
env = abs(sa);
phase = angle(sa);
phase_u = unwrap(phase);
dphase = diff(phase_u);
inst_freq = dphase*(fs/(2*pi));
figure()
subplot(2,1,1)
plot(T,y);
title
hold on
plot(T,env);
hold off
subplot(2,1,2)
plot(inst_freq)

%% Task 3
%Ex. 3.1
N = 2000; %2000 samples
Fs = 2000; %converting 2kHz into Hz
T = (0:N-1)/Fs; % time range
F0 = 5; %Hz
F1 = 200; %Hz
T1 = 1;
Y = chirp(T,F0,T1,F1, 'linear' );
h = hann(N);
y = Y.*h';
%computing analytical spectrum
yh = hilbert(y);

%creating the second Chirp
phi = -60; % Phase shift in degrees
y2 = chirp(T, F0, 1, F1, 'linear', phi);
%Using the analytical signal to apply the phase shift:
ya = hilbert(y); % Analytical signal
phi_rad = deg2rad(phi); % Phase shift in radians
y2_analytic = real(ya .* exp(1i * phi_rad));
%Calculate the phase shift between y and y2:
y2a = hilbert(y2_analytic); % Analytical signal of y2
delta_phi = -angle(sum(ya .* conj(y2a)) / sum(abs(y2a).^2));
delta_phi_deg = rad2deg(delta_phi); % Convert to degrees
disp(['Calculated phase shift: ', num2str(delta_phi_deg), ' degrees']);
%Plot the signals and compare:
figure;
subplot(2,1,1);
plot(T, y); hold on;
plot(T, y2a); hold off;
title('Chirp Signal and Phase Shifted Signal using chirp()');
legend('y', 'y2_{chirp}');
xlabel('Time (s)');
ylabel('Amplitude');
subplot(2,1,2);
plot(T, y); hold on;
plot(T, y2_analytic); hold off;
title('Chirp Signal and Phase Shifted Signal using Analytical Method');
legend('y', 'y2_{analytic}');
xlabel('Time (s)');
ylabel('Amplitude');

%Ex. 3.2
%Creating a time-varying phase-shifted signal (y3):
phase_shift = -2 * pi * T; % Time-varying phase shift
y3 = real(ya .* exp(1i * phase_shift));
%Calculate the average phase shift between y and y3
y3a = hilbert(y3); % Analytical signal of y3
avg_phase_shift = -angle(sum(ya .* conj(y3a)) / sum(abs(y3a).^2));
avg_phase_shift_deg = rad2deg(avg_phase_shift); % Convert to degrees
disp(['Average phase shift: ', num2str(avg_phase_shift_deg), ' degrees']);
%Estimate the time-varying phase shift
time_varying_phase_shift = angle(ya .* conj(y3a));
time_varying_phase_shift_unwrapped = unwrap(time_varying_phase_shift);

figure;
plot(T, time_varying_phase_shift_unwrapped);
hold on;
plot(T, phase_shift, '--');
title('Estimated vs Actual Time-Varying Phase Shift');
legend('Estimated Phase Shift', 'Actual Phase Shift');
xlabel('Time (s)');
ylabel('Phase (radians)');
hold off;
