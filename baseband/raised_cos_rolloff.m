%对升余弦滚降滤波器的特性研究（Rasied cosine roll-off filter）
Tb = 1; %码元传输速率
fs = 1000; %1000Hz的采样频率
t = -5*Tb:1/fs:5*Tb-1/fs; %时域范围
N = length(t);

%f = (-N/2:N/2-1)*fs/N; %频域范围,但是fft之后的效果不好，这里我们直接根据频域的公式来绘制频域图
f = -2/Tb:0.001:2/Tb; %画图时显示的频率范围,为了显示效果，这里我们不采用时域信号推出的频率分辨率（fs/N=1/length(t),length(t)为截短信号的长度）


fn = 1/2*Tb; %理想低通滤波器的截止频率

a = [0 0.5 0.75 1]; %滚降系数
H = zeros(length(a),length(t));
F = zeros(length(a),length(f));

for i = 1:length(a)
    H(i,:) = rcos(a(i),Tb,t);
end

figure('NumberTitle', 'off', 'Name','码元通过升余弦滚降特性信道后的时域响应');
plot(t,H(1,:));
hold on;
plot(t,H(2,:));
hold on;
plot(t,H(3,:));
hold on;
plot(t,H(4,:));
hold on;
legend('a=0','a=0.5','a=0.75','a=1','Fontsize',15);
grid on;
xlabel('时间t');
ylabel('时域响应');

%----升余弦特性低通信道的表达式----
for i=1:length(a)
    for j=1:length(f)
        if abs(f(j))>(1+a(i))/(2*Tb)
            F(i,j)=0;
        elseif abs(f(j))<(1-a(i))/(2*Tb)
            F(i,j)=Tb;
        else
            F(i,j)=0.5*Tb*(1+cos(pi*Tb/(a(i)+eps)*(abs(f(j))-(1-a(i))/(2*Tb))));
        end
    end
end

figure('NumberTitle', 'off', 'Name','升余弦滚降特性信道的频域响应');
plot(f,F(1,:));
hold on;
plot(f,F(2,:));
hold on;
plot(f,F(3,:));
hold on;
plot(f,F(4,:));
hold on;
legend('a=0','a=0.5','a=0.75','a=1','Fontsize',15);
grid on;
xlabel('频率f');
ylabel('频域响应');
axis([-2 2 0 1.2])
% figure('NumberTitle', 'off', 'Name','升余弦滚降特性信道的频域响应');
% F1 = abs(fft(H(1,:)));
% F1 = 1/N*fftshift(F1);
% 
% F2 = abs(fft(H(2,:)));
% F2 = 1/N*fftshift(F2);
% 
% F3 = abs(fft(H(3,:)));
% F3 = 1/N*fftshift(F3);
% 
% F4 = abs(fft(H(4,:)));
% F4 = 1/N*fftshift(F4);
% 
% plot(f,F1);
% hold on;
% plot(f,F2);
% hold on;
% plot(f,F3);
% hold on;
% plot(f,F4);
% hold on;
% legend('a=0','a=0.5','a=0.75','a=1','Fontsize',15);
% grid on;
% xlabel('频域f');
% ylabel('频域响应');
% xlim([-2/Tb 2/Tb]);
