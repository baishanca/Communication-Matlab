%研究基本的时域均衡（即直接在时域校正已经失真的响应波形），有限长横向滤波器
%关于自适应均衡器、非线性均衡器，放在signal process的学习part中进行


%----接收滤波器的输出波形x(t)----
Tb = 1;
N = 3; % 2N+1抽头的横向滤波器
t = -2*N*Tb:Tb:2*N*Tb; %t和xt用来计算抽头系数，因为2*N+1个抽头需要x_-2N到x_2N
xt = 1./(1+(2*t/Tb).^2);

t2 = -3*N*Tb:Tb:3*N*Tb; %t2和xt2，多定义一些时间，观察均衡后对其他点的影响，yk=sum(Ci*x_k-i),i:-N到N，这样可以计算到y_-2N到y_2N
xt2 = 1./(1+(2*t2/Tb).^2);

%迫零均衡器
X = zeros(2*N+1,2*N+1);
y = zeros(1,2*N+1); %均衡后的2*N+1个信号，y0=1，其余为0
y(N+1) = 1;

for i=1:length(y)
    X(i,:)=fliplr(xt(i:i+2*N)); %fliplr的作用是反序行向量，也可以是xt(i+2*N,-1,i)
end

%求解抽头系数
C = X\y'; %或者使用C=inv(X)*y'

%计算均衡后的值
len2 = length(xt2)-(2*N+1)+1; %length(xt2)-(2*N+1)+1为均衡后的序列的长度
yy = zeros(1,len2); 
tt = -(len2-1)/2:(len2-1)/2; %均衡后的序列时间轴
for i=1:len2
    yy(i)=fliplr(xt2(i:i+2*N))*C;
end

figure('NumberTitle', 'off', 'Name','时域迫零均衡：有限长横向滤波器');
stem(tt,xt2(N+1:end-N));
hold on;
stem(tt,yy);
xlabel('时间 t/Tb');
ylabel('信号');
legend('均衡前信号','均衡后信号','Fontsize',15);
