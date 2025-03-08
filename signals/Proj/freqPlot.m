function [f,mag,phase] = freqPlot(x,fs)
Y=fft(x);
mag=abs(Y);
phase=angle(Y);
N=length(x);
df=fs/N;
f=0:df:fs-df;

plot(f(1:floor(end/2)),mag(1:floor(end/2)))
end