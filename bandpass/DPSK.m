%研究2DPSK信号的时频特性（传输的是相对码）
%步骤：
%(1)指定初始码元状态，对二进制数字基带信号进行差分编码，即将绝对码变换成相对码（差分码）
%(2)对相对码进行绝对调相

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
fc = 1; %载波频率为10Hz
%两个载波的相位
phi_1 = -pi/2;
phi_2 = pi/2;
sr = (sign(randn(1,N))+1)/2; %原始信息序列

%----产生相对码----
ini = 0; %初始码元(参考码元)
rela = [ini zeros(1,length(sr))]; %初始化相对码序列
for i=1:length(sr)
    rela(i+1)=xor(sr(i),rela(i));
end

%tips:为了解决定时问题，可以采取B方式传输，即参考码元位的相位与信息码元位相差pi/2，见P187，设参考码元的相位为0

%----调制前准备----
rela2 = 1-rela;
rela2(1)=ini;
nrz = ones(1,fs); %单个NRZ波形
rela_conv = zeropad(rela,fs);
rela2_conv = zeropad(rela2,fs);
rela_ini_conv = [1 zeros(1,length(rela_conv)-1)];
data = conv(rela_conv,nrz);
data = data(1:length(t));
data2 = conv(rela2_conv,nrz);
data2 = data2(1:length(t));
data_ini = conv(rela_ini_conv,nrz);
data_ini = data_ini(1:length(t));

%----载波调制----
carrier_ini= cos(2*pi*fc*t); %参考相位的载波，第一个码元位参考码元
carrier1= cos(2*pi*fc*t+phi_1); %信号为1时的载波频率
carrier2= cos(2*pi*fc*t+phi_2 ); %信号为0时的载波频率

dpsk = data_ini.*carrier_ini+data.*carrier1+data2.*carrier2;
figure('NumberTitle', 'off', 'Name','DPSK信号');
plot(t,dpsk);
xlabel('t/s');
ylabel('幅度');
title('DPSK信号波形');

