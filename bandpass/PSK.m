%研究2PSK信号的时频特性
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
fc = 10; %载波频率为10Hz,可以调小载波频率（比如1Hz观察相邻码元间的衔接情况）
%两个载波的相位
phi_1 = 0;
phi_2 = pi;

sr = (sign(randn(1,N))+1)/2; %原始信息序列
sr2 = 1-sr;
sr_conv = zeropad(sr,fs);
sr2_conv = zeropad(sr2,fs);
nrz = ones(1,fs); %单个NRZ波形
data = conv(sr_conv,nrz);
data = data(1:length(t));
data2 = conv(sr2_conv,nrz);
data2 = data2(1:length(t));

%----产生PSK信号----
carrier1= sin(2*pi*fc*t+phi_1); %信号为1时的载波频率
carrier2= sin(2*pi*fc*t+phi_2 ); %信号为0时的载波频率

carrier3= cos(2*pi*fc*t+phi_1); %信号为1时的载波频率
carrier4= cos(2*pi*fc*t+phi_2 ); %信号为0时的载波频率

psk_sin = data.*carrier1+data2.*carrier2;
psk_cos = data.*carrier3+data2.*carrier4;

len = length(t);
f = (-len/2:len/2-1)*fs/len; %频率范围
psk_f = abs(fft(psk_sin));
psk_f = 1/fs*fftshift(psk_f);

figure('NumberTitle', 'off', 'Name','PSK信号的时域和频域分析');
subplot(4,1,1);
plot(t,data);
xlabel('t/s');
ylabel('幅度');
title('原始信号波形');
subplot(4,1,2);
plot(t,psk_sin);
xlabel('t/s');
ylabel('幅度');
title('2PSK-sin波形');
subplot(4,1,3);
plot(t,psk_cos);
xlabel('t/s');
ylabel('幅度');
title('2PSK-cos波形');
subplot(4,1,4);
plot(f,psk_f);
xlabel('f/Hz');
ylabel('幅度');
title('2PSK信号功率谱');

%tips：由于两个载波的波形相同，仅仅极性相反，因此2PSK调制等效于双极性码的ASK调制，只不过是双极性NRZ基带信号频谱的搬移，而不是单极性NRZ