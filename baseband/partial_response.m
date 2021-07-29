%研究部分响应的特性
%部分响应通过引入有规律的码间干扰，在接收端进行消除，在频带利用率最大化的情况下实现等效的无码间干扰

%---研究第I类部分响应的时域和频域响应----
Tb = 1; %码元长度
fs = 103.7; %采样频率  %这里是个迷，因为和第9行的那个eps，需要调参才能使得图形完整
dt = Tb/fs; %采样时间间隔
t = -3.5*Tb:dt:3.5*Tb; %时域的时间区间
gt = 4/pi*cos(pi*t/Tb)./(1-4*t.^2/Tb^2+eps); %第I类部分响应的时域表达式

figure('NumberTitle', 'off', 'Name','第I类部分响应信号特性研究');
subplot(2,1,1);
plot(t,gt);
axis([-3.5, 3.5 -0.5 1.5]);
xlabel('时间t');
ylabel('第I类部分响应的时域信号');
grid on;

f = -2/Tb:0.001:2/Tb; %画图时显示的频率范围,为了显示效果，这里我们不采用时域信号推出的频率分辨率,自定义分辨率0.001
Gf = zeros(1,length(f));
%----第I类部分响应的频域表达式----
for j = 1:length(f)
    if abs(f(j))>1/2*Tb
        Gf(j)=0;
    else
        Gf(j)=2*Tb*cos(pi*f(j)*Tb);
    end
end
subplot(2,1,2);
plot(f,Gf); %可以看到，部分响应的频带利用率与理想低通信道相同
axis([-2, 2 -0.5 2.5]);
xlabel('频率f');
ylabel('第I类部分响应的频域特性');
grid on;

%---但是直接判决会出现“差错传播现象”，故下面进行“预编码-相关编码-模2判决”的仿真
ak = [1 0 1 1 0 0 0 1 0 1 1];
b_ini = 0; %差分码的初始码元，需要指定一个初始码元
b_k =[b_ini zeros(1,length(ak))];
%计算差分码（预编码）
for i = 1:length(ak)
    b_k(i+1) = xor(ak(i),b_k(i));
end

Ck = b_k(1:end-1) + b_k(2:end); %相关编码
rec_a = mod(Ck,2); %模2判决
disp(rec_a);