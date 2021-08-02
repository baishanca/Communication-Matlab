%研究2ASK信号的时频特性
clear all;
close all;

%----原始信号码元参数----
Tb = 1; %码元长度
fs = 500; %采样频率
dt = 1/fs; %采样时间间隔
N = 20; %码元数量
t = 0:dt:(N*fs-1)*dt; %时域范围

%----载波参数----
Ac = 1; %载波幅度
fc = 50; %载波频率
phi = 0; %初始相位

%----产生原始的二进制码元----
sr = (sign(randn(1,N))+1)/2; %原始信息序列
sr_conv = zeropad(sr,fs);
nrz = ones(1,fs); %单个NRZ波形
data = conv(sr_conv,nrz);
data = data(1:length(t));

%----产生ASK信号----
carrier = cos(2*pi*fc*t);
ask = data.*carrier;

len = length(t);
f = (-len/2:len/2-1)*fs/len; %频率范围
ask_f = abs(fft(ask));
ask_f = 1/fs*fftshift(ask_f);


figure('NumberTitle', 'off', 'Name','ASK信号的时域和频域分析');
subplot(3,1,1);
plot(t,data);
xlabel('t/s');
ylabel('幅度');
title('原始信号波形');
subplot(3,1,2);
plot(t,ask);
xlabel('t/s');
ylabel('幅度');
title('2ASK波形');
subplot(3,1,3);
plot(f,ask_f);
xlabel('f/Hz');
ylabel('幅度');
title('2ASK信号功率谱'); %可以看到是NRZ基带频谱的频谱搬移，-fc和fc