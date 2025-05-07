clc;
clear all;
close all;
%% Transfer Function
R = 10;
C = 1e-6;
L = 4e-6;
fs = 3e7/(2*pi); % Simulation sampling frequency
% Transfer function:
num=[1 0];
den=[(C*R) 1 (R/L)];
SYS = tf(num,den);
%% 2.1 Sinusoidal Excitation

% Sine wave frequencies
frequencies = [70e3, 80e3, 90e3]; % Hz
figure(4); % New figure for sine response plots
figure(5); % New figure for Bode plot comparison
figure(6); % New figure for simulated Bode plot 

for i = 1:length(frequencies)
    InputFreq = frequencies(i);
    period = 1 / InputFreq;

    % Simulate the model
    out_sin = sim('Lab5_RLC_sin.slx');

    % Get time and output data
    time = out_sin.tout;
    output_signal = out_sin.y1.Data;
    input_signal = out_sin.x1.Data; % Get input signal from simulation

    % Plot the response
    figure(4);
    subplot(length(frequencies), 1, i);
    hold on
    plot(time, input_signal);
    plot(time, output_signal);
    legend('input signal','output signal')
    hold off
    title(['Response to ' num2str(InputFreq/1e3) ' kHz Sine Wave']);
    xlabel('Time (s)');
    ylabel('amplitude');
    grid on;

    % Analyze amplitude and phase
    output_amplitude = max(output_signal) - min(output_signal) / 2;

    % Calculate phase shift using cross-correlation
    [correlation, lags] = xcorr(output_signal, input_signal);
    [~, max_index] = max(correlation);
    time_shift = lags(max_index) / fs; % Time shift in seconds
    output_phase_simulated = -time_shift * InputFreq * 360; % Phase shift in degrees
    
    %bode plot from fft
    X = fft(input_signal);
    Y = fft(output_signal);
    G = Y./X;
    G_mag=abs(G);
    N=length(input_signal);
    df=fs/N;
    f=(0:df:fs-1);
    
    % Correct for phase wrapping
    output_phase_simulated = mod(output_phase_simulated + 180, 360) - 180;

    % Get Bode plot data for comparison
    [mag, phase_bode, w] = bode(SYS, 2*pi*InputFreq);

    % Display results
    outputamp_db = 20*log10(output_amplitude);
    mag_db = 20*log10(mag);
    disp(['Frequency: ' num2str(InputFreq/1e3) ' kHz, Simulated Amplitude: ' num2str(outputamp_db) ...
          ', Bode Mag (dB): ' num2str(mag_db) ', Simulated Phase: ' num2str(output_phase_simulated) ...
          ', Bode Phase: ' num2str(phase_bode)]);
    % Plot Bode phase for comparison
    figure(5);
    subplot(length(frequencies), 1, i);
    bode(SYS); % Plot the full Bode plot
    hold on;
    plot(2*pi*InputFreq, phase_bode, 'ro', 'MarkerSize', 8); % Plot Bode phase as a red circle
    hold off;
    title(['Bode Phase at ' num2str(InputFreq/1e3) ' kHz']);
    xlabel('Frequency (rad/s)');
    ylabel('Phase (degrees)');
    grid on;
    legend('Bode Phase Curve','Bode Phase (at InputFreq)');
    figure(6);
    subplot(length(frequencies), 1, i);
    semilogx(f(1:floor(N/2))*2*pi,20*log10(G_mag(1:floor(N/2))))
    title('Bode Plot from FFT (Simulation Data)');
    xlabel('Frequency (rad/s)');
    ylabel('Magnitude (dB)');
    xlim([10e3,10e6]);
    grid on;
end
%% 2.2 
%output from 1.2
out_step = sim('Lab5_RLC.slx');
output = out_step.y1.Data;
input = out_step.x1.Data;
N=length(output);
% Parameters
frequency = 70e3; % 70 kHz
amplitude = 1; % Amplitude of the sine wave

% Time vector
t = 0:1/fs:(N/fs);
t_conv=0:1/(fs):2*(((N)/fs)-1/(2*fs));
% Sine wave
sineWave = amplitude * sin(2 * pi * frequency * t);
%convoluting
out_conv=conv(sineWave,output);
%simulating 70khz
InputFreq = frequencies(1);
out_sin = sim('Lab5_RLC_sin.slx');
time = out_sin.tout;
output_signal = out_sin.y1.Data;
%displaying results
figure(7)
hold on
plot(t,sineWave)
plot(t_conv,out_conv,'r')
plot(time,output_signal,'--k')
hold off
xlim([0,2e-4]);
title(['Comparison of convoluted vs simulated outputs']);
xlabel('time(s)');
ylabel('amplitude');
grid on;
legend('input sine wave', 'convoluted output','simulated output');