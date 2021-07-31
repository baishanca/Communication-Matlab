clc;
%非线性调制---FM modulation(频率调制)
Am = 2;
Ac = 2;
fm = 1;
fc = 10;
Kf = 5; %调制指数
phi_c = 0; %初始相位

fs = 100; %采样频率为100Hz
t = 0:1/fs:5-1/fs; %时间序列
N = length(t);
f = (-N/2:N/2-1)*fs/N; %频率序列

mt = Am*cos(2*pi*fm*t); %调制信号
mt2 = Am/(2*pi*fm)*sin(2*pi*fm*t); %mt2为原信号mt的积分，此处我们为手动计算出的积分解析式，然后代入t



st = Ac*cos(2*pi*fc*t+2*pi*Kf*mt2);

z_m = abs(fft(mt));
z_m1 = fftshift(z_m);

z_s = abs(fft(st));
z_s1 = fftshift(z_s);

%-----解调过程------
%采用非相干解调的方法（即鉴频器（微分器+包络检波））
%微分器：将幅度稳定的调频信号变成幅度和频率都随着调制信号m(t)变化的调频调幅波

%经过微分器：

% de_st = zeros(1,length(st));
% for k=1:length(st)-1
%     de_st(k)=(st(k+1)-st(k))/(1/fs);
% end

% de_st = diff(st)./diff(t); %diff为差分函数
% de_st = [de_st 0]; %最后补0


de_st = -Ac*(2*pi*fc+Kf*mt).*sin(2*pi*fc*t+2*pi*Kf*mt2); %调频调幅波
env = Ac*(2*pi*fc+Kf*mt);

figure();
subplot(4,1,1);
plot(t,st);
hold on;
plot(t,mt,'r--');
xlabel('时间t');
ylabel('原始信号及调频信号');

subplot(4,1,2);
plot(f,z_m1);
xlabel('频率f');
ylabel('原始信号的频谱');

subplot(4,1,3);
plot(f,z_s1);
xlabel('频率f');
ylabel('FM信号的频谱'); %幅度谱

subplot(4,1,4);
plot(t,de_st);
hold on;
plot(t,env,'r--');
xlabel('时间t');
ylabel('解调后的信号');