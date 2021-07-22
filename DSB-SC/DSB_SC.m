clc;
%DSB-SC(双边带抑制载波调制)
Am = 3;
Ac = 6;
fm = 1;
fc = 10;

fs = 100; %采样频率为100Hz
t = 0:1/fs:10-1/fs;
N = length(t);
f = (-N/2:N/2-1)*fs/N; %fs/N为最小频率间隔

ori_signal = Am*cos(2*pi*fm*t); %调制信号
DSB_signal = ori_signal.*(Ac*cos(2*pi*fc*t)); %已调信号
dem_signal = DSB_signal.*cos(2*pi*fc*t); %解调过程

z1 = real(fft(ori_signal));
z2 = real(fft(DSB_signal));
z_1 = fftshift(z1);
z_2 = fftshift(z2);

z3 = real(fft(dem_signal));

pass_band = 3;
cover_spectrum = lowpass_filter(f,fftshift(z3),pass_band);
cover_signal = real(ifft(fftshift(cover_spectrum))); %fftshift(cover_spectrum)为未经过移动的DFT频谱

figure('NumberTitle', 'off', 'Name','DSB-SC信号的调制与相干解调');
subplot(7,1,1);
plot(t,ori_signal);
xlabel('时间t');
ylabel('原始信号m(t)');

subplot(7,1,2);
plot(t,DSB_signal);
xlabel('时间t');
ylabel('已调信号'); 

subplot(7,1,3);
plot(f,z_1);
xlabel('频率f');
ylabel('原始信号的频谱');

subplot(7,1,4);
plot(f,z_2);
xlabel('频率f');
ylabel('已调信号的频谱'); %没有载波分量，但带宽依然是调制信号的2倍

subplot(7,1,5);
plot(f,fftshift(z3));
xlabel('频率f');
ylabel('相乘后信号的频谱');

subplot(7,1,6);
plot(f,cover_spectrum);
xlabel('频率f');
ylabel('解调信号的频谱'); %经过低通滤波器

subplot(7,1,7);
plot(t,cover_signal);
xlabel('时间t');
ylabel('恢复信号的波形');

%tips:为什么fft和ifft是取real()?
%因为信号的频域如果是对称的话，则时域应该是实信号，故取实部