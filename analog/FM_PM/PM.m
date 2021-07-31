clc;
%非线性调制---PM modulation(相位调制)
Am = 2;
Am2 = 0.05;
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

z_m = abs(fft(mt));
z_m1 = fftshift(z_m);

z_s = abs(fft(st));
z_s1 = fftshift(z_s);

%窄带角度调制，即相位远小于1，可以近似为常规幅度调制（AM），可以采用相干解调
%相较于常规幅度调制（AM），可以看到窄带调制幅度变化很小(几乎没有变化），AM中没有相位的变化
nb_mt = Am2*cos(2*pi*fm*t);
st2 = Ac*cos(2*pi*fc*t+Kp*nb_mt);

z_nb = abs(fft(nb_mt));
z_nb1 = fftshift(z_nb);

z_st_nb = abs(fft(st2));
z_st_nb2 = fftshift(z_st_nb);



figure();
subplot(6,1,1);
plot(t,st);
hold on;
plot(t,mt,'r--');
xlabel('时间t');
ylabel('原始信号及调相信号');

subplot(6,1,2);
plot(f,z_m1);
xlabel('频率f');
ylabel('原始信号的频谱');

subplot(6,1,3);
plot(f,z_s1);
xlabel('频率f');
ylabel('PM信号的频谱'); %幅度谱

subplot(6,1,4);
plot(t,st2);
hold on;
plot(t,nb_mt,'r--');
xlabel('时间t');
ylabel('窄带角度调制信号');

subplot(6,1,5);
plot(f,z_nb1);
xlabel('频率f');
ylabel('原始信号的频谱');

subplot(6,1,6);
plot(f,z_st_nb2);
xlabel('频率f');
ylabel('窄带PM信号的频谱'); %幅度谱

%tips：FM信号随着调制信号m(t)的增加，带宽内的谐波数量会减少，而对于PM信号没有影响
