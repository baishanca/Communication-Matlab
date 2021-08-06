clc;
%AM Modulation
%此时调制指数u=Am/Ac=0.6
Am = 3;
Ac = 6;
fm = 0.5;
fc = 4;

fs = 50; %采样频率为50Hz
t = 0:1/fs:10-1/fs;

m_t = Am*cos(2*pi*fm*t);
Am_signal = (m_t + Ac).*cos(2*pi*fc*t);

figure('NumberTitle', 'off', 'Name','AM信号的调制与相干解调');
subplot(7,1,1);
plot(t,m_t);
xlabel('时间t');
ylabel('原始信号m(t)');



subplot(7,1,2);
plot(t,Am_signal);
axis([0 10 -10 10]);
xlabel('时间t');
ylabel('已调信号');

%绘制频谱
N = length(t); %获取时域采样点数,共500个点
z = real(fft(Am_signal)); %DFT变换
f = (0:N-1)*fs/N;

z2 = fftshift(z);
f2 = (-N/2:N/2-1)*fs/N; %频域重排

subplot(7,1,3);
plot(f2,z2); %显示的是DFT频谱
xlabel('频率f');
ylabel('Amplitude');

%Demodulation(解调)
AM_mod = Am_signal.*cos(2*pi*fc*t);
subplot(7,1,4);
plot(t,AM_mod);
xlabel('时间t');
ylabel('已调信号与载波相乘');
%plot(t,AM_mod);

spectrum_AM_mod = abs(fft(AM_mod));
subplot(7,1,5);
plot(f2,fftshift(spectrum_AM_mod));
xlabel('频率f');
ylabel('相乘后信号的频谱');

pass_band = 1; %低通截止频率为1Hz
lowpass_spectrum = lowpass_filter(f2,fftshift(spectrum_AM_mod),pass_band); %通过理想低通滤波器后的频谱特性
subplot(7,1,6);
plot(f2,lowpass_spectrum);
xlabel('频率f');
ylabel('理想低通后的频谱');

rec_signal = real(ifft(fftshift(lowpass_spectrum))); %恢复出的时域信号，此时还包括直流分量Ac/2,且原信号的幅度变为原来的一半
subplot(7,1,7);
plot(t,rec_signal);
xlabel('时间t');
ylabel('相干解调恢复出的信号');