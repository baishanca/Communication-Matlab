%研究2FSK信号的时频特性
clear all;
close all;

%----原始信号码元参数----
Tb = 1; %码元长度
fs = 500; %采样频率
dt = 1/fs; %采样时间间隔
N = 20; %码元数量
t = 0:dt:(N*fs-1)*dt; %时域范围

%----两种载波的参数----
Ac_1 = 1;
Ac_2 = 1;
phi_1 = 0;
phi_2 = 0;
fc_1 = 5; %5Hz
fc_2 = 15; %15Hz
sr = (sign(randn(1,N))+1)/2; %原始信息序列
sr2 = 1-sr;
sr_conv = zeropad(sr,fs);
sr2_conv = zeropad(sr2,fs);
nrz = ones(1,fs); %单个NRZ波形
data = conv(sr_conv,nrz);
data = data(1:length(t));
data2 = conv(sr2_conv,nrz);
data2 = data2(1:length(t));

%----产生FSK信号----
carrier1= cos(2*pi*fc_1*t+phi_1); %信号为1时的载波频率
carrier2= cos(2*pi*fc_2*t+phi_2 ); %信号为0时的载波频率
fsk = data.*carrier1+data2.*carrier2;

len = length(t);
f = (-len/2:len/2-1)*fs/len; %频率范围
fsk_f = abs(fft(fsk));
fsk_f = 1/fs*fftshift(fsk_f);

figure('NumberTitle', 'off', 'Name','FSK信号的时域和频域分析');
subplot(3,1,1);
plot(t,data);
xlabel('t/s');
ylabel('幅度');
title('原始信号波形');
subplot(3,1,2);
plot(t,fsk);
xlabel('t/s');
ylabel('幅度');
title('2FSK波形');
subplot(3,1,3);
plot(f,fsk_f);
xlabel('f/Hz');
ylabel('幅度');
title('2FSK信号功率谱');

% tips:|f2-f1|>fb时，功率谱出现双峰，<fb时为单峰，fb=1/Tb为基带信号（NRZ）的带宽,FSK信号的带宽为|f2-f1|+2fb