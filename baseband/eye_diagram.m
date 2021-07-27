close all;
clear all;
%对双极性基带传输，信道是升余弦滚降响应，绘制接收端的信号波形和眼图

%----生成双极性基带信号----
symbol_num = 20; %码元数量
data = sign(randn(1,symbol_num));
fs = 101; %采样频率，单个码元内的采样数量,为什么是101，因为18行添加的eps，如果是偶数，会出现冲激，图会很难看，故取单数
data_conv = zeropad(data,fs); %生成需要卷积的序列


%----基带冲激响应（升余弦滚降）----
a = 1; %滚降系数
Ts = 1; %码元长度为1
dt = Ts/fs; %采样间隔
t_sample = -3*Ts:dt:3*Ts; %采样的时间范围

nrz = ones(1,fs); %单个NRZ波形
ht = sinc(t_sample/Ts).*cos(pi*a/Ts*t_sample)./(1-4*a^2.*t_sample.^2/Ts^2+eps); %信道响应
st1 = conv(data_conv,nrz); %原始NRZ码元信息
st2 = conv(data_conv,ht); %升余弦滚降信号

t1 = 0:dt:symbol_num*Ts-dt; 
t2 = -3*Ts:dt:(symbol_num+3)*Ts-dt; %整个信号的时域长度，每个码元两边的距离为3*Ts
figure('NumberTitle', 'off', 'Name','双极性基带信号的升余弦滚降传输');
subplot(2,1,1);
plot(t1,st1(1:length(t1)));
axis([0 20 -1.5 1.5]);
grid on;
hold on;
plot(t1,zeros(1,length(t1)),'r--');
xlabel('时间t');
ylabel('双极性NRZ信号：原始码元');

subplot(2,1,2);
plot(t2,st2);
axis([0 20 -1.5 1.5]);
grid on;
xlabel('时间t');
ylabel('升余弦滚降传输信号');