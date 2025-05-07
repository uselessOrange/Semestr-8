clc;
clear all;
close all;
%% 1.1 Transfer Function
R = 10; % 5, 100
C = 1e-6;
L = 4e-6;
fs = 3e7/(2*pi); % Simulation sampling frequency
% Transfer function:
num=[1 0];
den=[(C*R) 1 (R/L)];
SYS = tf(num,den);
figure(1);
bode(SYS);
title('Bode Plot from Transfer Function');
[y,tOut] = impulse(SYS);
y=y/100000;
figure(2)
plot(tOut,y)
xlim([0,1e-4]);
title('Impulse Response from TF');
xlabel('Time (s)');
ylabel('Amplitude');
w0=1/sqrt(L*C)
%% 1.2 Simulink Simulation
out = sim('Lab5_RLC.slx');
figure(3);
plot(out.y1.Time, out.y1.Data);
title('Impulse Response from Simulink');
xlabel('Time (s)');
ylabel('Amplitude');
xlim([0,1e-4]);
%% 1.3 Bode Plot from FFT (from simulation data)
% Calculate FFT
X = fft(out.x1.Data);
Y = fft(out.y1.Data);
N=length(out.x1.Data);
G = Y./X;
G_mag=abs(G);
df=fs/N;
% Frequency vector (rad/s)
f=(0:df:fs-1);
% Find index for cutoff frequency
cutoff_freq = 1e7;
[~, cutoff_index] = min(abs(f - cutoff_freq));
figure(4);
subplot(2, 1, 1);
semilogx(f(1:floor(N/2))*2*pi,20*log10(G_mag(1:floor(N/2))))
title('Bode Plot from FFT (Simulation Data)');
xlabel('Frequency (rad/s)');
ylabel('Magnitude (dB)');
xlim([10e3,10e6]);
grid on;
subplot(2, 1, 2);
G_phase=angle(G);
semilogx(f(1:floor(N/2))*2*pi,rad2deg(G_phase(1:floor(N/2))))
xlim([10e3,10e6]);
xlabel('Frequency (rad/s)');
ylabel('Phase (degrees)');
grid on;
%% 1.4 Damping Factor Calculation
%manually checking and calculating values
%Half power method
omegar = 502513;
omega1 = 452261;
omega2 = 552764;
epsilon1 = (omega2 - omega1)/(2*omegar)
%logarithmic damping decrement:
%for R=10
x10 = 1.132e-2;
x11 = 6.033e-3;
epsilon10 = log(x10/x11)/(2*pi)
%for R=100
x100 = 1.921e-3;
x101 = 1.844e-3;
epsilon100 = log(x100/x101)/(2*pi)
%for R=5
x5 = 1.257e-2;
x6 = 3.470e-3;
epsilon5 = log(x5/x6)/(2*pi)

