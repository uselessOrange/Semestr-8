%% Lab 2
clear all

%% Task 1
%Ex. 1.1
fs = 1000; % sampling frequency
N = 1000; % number of samples
t = (0:N-1)/fs; % time range
f1 = 10; %frequency one
f2 = 300; %frequency two
a1 = 1; % amplitude one
a2 = 0.2; % amplitude two
y = a1*sin(2*pi*f1*t) + a2*sin(2*pi*f2*t); 
%Rectangular Window
h = 1/21*rectwin(21);
wvtool(h)
%Applying Convolution
yc = conv(y,h);
yc = yc(1:1000);
%Filter function
yf = filter(h,1,y);
figure(2)
plot(t,y)
hold on
plot(t,yf)
plot(t,yc,'-.')
hold off
xlabel('time (s)');
ylabel('amplitude (~)');
legend('Original','Filter Function', 'Convolution Function');

%Freqz Filter
figure(3)
freqz(h,1,N,fs);

%Ex. 1.2
yz = filtfilt(h,1,y);
figure(4)
plot(t,y)
hold on
plot(t,yf)
plot(t,yz,'-.')
hold off
xlabel('time (s)')
ylabel('amplitude (~)')
legend('Filter Function', 'Zero-phase Function') % whats noticed here is group delay

yc2 = filter(h,1,y);
yc_reverse = yc2(end:-1:1);
yc_rev_conv =  filter(h,1,yc_reverse);
yz2 = yc_rev_conv(end:-1:1);
yz2 = yz2(1:1000);

figure(5)
plot(t,yf)
hold on
plot(t,yz)
plot(t,yz2,'-.')
hold off
xlabel('time (s)')
ylabel('amplitude (~)')
legend('Original Signal','Filtfilt Function', 'Zero-phase Function')

%Ex. 1.3
h2 = 1/11*rectwin(11);
figure(6)
freqz(h2,1,N,fs);
figure(7)
h3 = 1/51*rectwin(51);
freqz(h3,1,N,fs);

%% Task 3
[data,fs] = audioread(['ktoto.wav']);

% Num – numerator of FIR
dataF(:,1) = filter(Num,1,squeeze(data(:,1)));
dataF(:,2) = filter(Num,1,squeeze(data(:,2)));
