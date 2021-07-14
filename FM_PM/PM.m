clc;
%非线性调制---PM modulation(相位调制)
Am = 2;
Ac = 2;
fm = 1;
fc = 10;
Kp = 5; %调制指数
phi_c = 0; %初始相位

fs = 100; %采样频率为100Hz
t = 0:1/fs:5-1/fs; %时间序列
N = length(t);
f = (-N/2:N/2-1)*fs/N; %频率序列

mt = Am*cos(2*pi*fm*t); %调制信号

st = Ac*cos(2*pi*fc*t+Kp*mt);

z_m = real(fft(mt));
z_m1 = fftshift(z_m);

z_s = abs(fft(st));
z_s1 = fftshift(z_s);

figure();
subplot(3,1,1);
plot(t,st);
hold on;
plot(t,mt,'r--');
xlabel('时间t');
ylabel('原始信号及调相信号');

subplot(3,1,2);
plot(f,z_m1);
xlabel('频率f');
ylabel('原始信号的频谱');

subplot(3,1,3);
plot(f,z_s1);
xlabel('频率f');
ylabel('PM信号的频谱'); %幅度谱

%tips：FM信号随着调制信号m(t)的增加，带宽内的谐波数量会减少，而对于PM信号没有影响
