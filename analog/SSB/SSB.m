clc;
%SSB(单边带调制)，此处保留上边带（uperside band）
Am = 3;
Ac = 6;
fm = 1;
fc = 10;

fs = 100; %采样频率为50Hz
t = 0:1/fs:10-1/fs;
N = length(t);
f = (-N/2:N/2-1)*fs/N; %fs/N为最小频率间隔

m_t = Am*cos(2*pi*fm*t);
mt = imag(hilbert(m_t)); %hilbert返回的是解析信号，即m_t + mt*j,其中mt是m_t的希尔伯特变换

%上边带信号
ssb = 0.5*m_t.*cos(2*pi*fc*t)-0.5*mt.*sin(2*pi*fc*t);
z_ssb = real(fft(ssb));
z_ssb2 = fftshift(z_ssb);

figure('NumberTitle', 'off', 'Name','希尔伯特方法产生SSB信号及其频谱');
subplot(2,1,1);
plot(t,ssb);
xlabel('时间t');
ylabel('SSB信号m(t)');

subplot(2,1,2);
plot(f,z_ssb2);
xlabel('频率f');
ylabel('ssb频谱');

%解调方法同样为相干解调，不做赘述
