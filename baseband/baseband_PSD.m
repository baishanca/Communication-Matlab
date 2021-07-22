% 绘制单极性、双极性归零码和非归零码的功率谱密度（PSD of NRZ and RZ）
clear all; %删除工作区变量，清空内存
close all;
N = 500; %单个码元内的采样数量(采样频率)

dt = 1/N; %采样时间间隔
M = 10; %码元数量
t = 0:dt:(M*N-1)*dt; %总时间
len = length(t);

sr = (sign(randn(1,M))+1)/2; %长度为M的二进制（0,1）随机码元序列，sign为符号函数
sr_conv = zeropad(sr,N); %生成卷积所需要的序列，即在每个原始码元后面添加N-1个0

nrz = ones(1,N); %单个NRZ波形
rz = [ones(1,N/2) zeros(1,N/2)]; %单个RZ波形

%----单极性码时域-----
data_nrz = conv(sr_conv,nrz);
data_rz = conv(sr_conv,rz);

data_nrz = data_nrz(1:len); %原始码元序列sr的单极性nrz波形
data_rz = data_rz(1:len); %原始码元序列sr的单极性rz波形


%----双极性码时域----
sr2 = sr*2-1; %双极性码的原始信息序列
sr2_conv = zeropad(sr2,N); %生成卷积所需要的序列，即在每个原始码元后面添加N-1个0

data2_nrz = conv(sr2_conv,nrz);
data2_rz = conv(sr2_conv,rz);

data2_nrz = data2_nrz(1:len); %原始码元序列sr的单极性nrz波形
data2_rz = data2_rz(1:len); %原始码元序列sr的单极性rz波形

% %----功率谱密度的分析----
f = (-len/2:len/2-1)*N/len; %频率范围
f_data_nrz = abs(fft(data_nrz));
f_data_nrz = 1/N*fftshift(f_data_nrz);

f_data_rz = abs(fft(data_rz));
f_data_rz = 1/N*fftshift(f_data_rz);

f_data2_nrz = abs(fft(data2_nrz));
f_data2_nrz = 1/N*fftshift(f_data2_nrz);

f_data2_rz = abs(fft(data2_rz));
f_data2_rz = 1/N*fftshift(f_data2_rz);


figure('NumberTitle', 'off', 'Name','单极性/双极性---NRZ/RZ的时域波形图');
subplot(4,1,1);
plot(t,data_nrz);
xlabel('时间t');
ylabel('单极性NRZ');

subplot(4,1,2);
plot(t,data_rz);
xlabel('时间t');
ylabel('单极性RZ');

subplot(4,1,3);
plot(t,data2_nrz);
hold on;
plot(t,zeros(1,length(t)),'r--');
xlabel('时间t');
ylabel('双极性NRZ');

subplot(4,1,4);
plot(t,data2_rz);
hold on;
plot(t,zeros(1,length(t)),'r--');
xlabel('时间t');
ylabel('双极性RZ');

figure('NumberTitle', 'off', 'Name','单极性/双极性---NRZ/RZ的PSD图');
subplot(4,1,1);
plot(f,f_data_nrz);
xlabel('频率f');
ylabel('单极性NRZ');

subplot(4,1,2);
plot(f,f_data_rz);
xlabel('频率f');
ylabel('单极性RZ');

subplot(4,1,3);
plot(f,f_data2_nrz);
xlabel('频率f');
ylabel('双极性NRZ');

subplot(4,1,4);
plot(f,f_data2_rz);
xlabel('频率f');
ylabel('双极性RZ');