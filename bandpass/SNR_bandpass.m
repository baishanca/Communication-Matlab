%研究各种信号的抗噪声性能（直接引用前几个文件的基础代码）
clear all;
close all;
%tips: biterr函数、randn函数
%-------------------------ASK---------------------------
%----原始信号码元参数----
Tb = 1; %码元长度
fs = 100; %采样频率
dt = 1/fs; %采样时间间隔
N = 1e5; %码元数量，数量大，便于统计，避免较少的码元数带来的偶然性 
t = 0:dt:(N*fs-1)*dt; %时域范围

%----载波参数----
Ac = 1; %载波幅度
fc = 30; %载波频率
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
    
%----匹配滤波----
r_db = 0:15; %信噪比-dB
Eb = Tb*Ac*Ac/2; %单个比特的信号功率（J/bit）
pe = zeros(1,length(r_db));
pe_ideal = zeros(1,length(r_db));
for i=1:length(r_db)
    r = 10^(r_db(i)/10);
    n0 = Eb/r; %单边噪声功率谱密度
    delta = n0/2*fs; %噪声功率
    n = sqrt(delta)*randn(1,length(ask)); %噪声信号
%     reciv = awgn(ask,r_db(i)); %也可以这样
    reciv = ask+n; %接收信号
    
    %匹配滤波器
    t1 = 0:dt:Tb-dt;
    h = cos(2*pi*fc*t1);
    
    %滤波
    recov_signal = conv(reciv,h)*dt;
    
    %包络检波
    t2 = 0:dt:(length(recov_signal)-1)*dt;
    z = hilbert(recov_signal); %z为解析信号
    z1 = z.*exp(-sqrt(-1)*2*pi*fc*t2); %z1为复包络
    envlp = abs(z1);
%     subplot(2,1,1);
%     plot(t,data);
%     subplot(2,1,2);
%     plot(t2,recov_signal);
    
    %判决
    recov_sym = zeros(1,N);
    Vth = Ac/4; %判决门限，余弦信号卷积之后，高度会下降一半，故用Ac/4
    for j=1:N
        if envlp(j*Tb/dt) > Vth
            recov_sym(j)=1;
        else
            recov_sym(j)=0;
        end
    end
    [err_num,err_pro] = biterr(sr,recov_sym); %计算误码个数和误码率
    pe(i)=err_pro;
    pe_ideal(i) = 0.5*erfc(sqrt(0.25*r));
    %pe_ideal(i) = 0.5*exp(-0.25*r);
end

figure();
semilogy(r_db,pe,'-*');
hold on;
semilogy(r_db,pe_ideal);
legend('实际误码率','理论误码率');
grid on;

