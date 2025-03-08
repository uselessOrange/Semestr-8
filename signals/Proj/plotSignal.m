function [x,t,metadata] = plotSignal(x,fs,downsampleRate)


if nargin < 3
    downsampleRate=1;
end

[m,n]=size(x);
if m<n
    x=x';
end

N=length(x);
N=N/downsampleRate;
fs=fs/downsampleRate;

x=x(1:downsampleRate:end);

t=(0:N-1)/fs;
t=t';

plot(t,x)
title('Signal in Time');
xlabel('Time [s]')
ylabel('Amplitude')
metadata.fs=fs;
metadata.N=N;
metadata.downsampleRate=downsampleRate;


