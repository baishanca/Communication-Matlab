% 评估二进制单极性和双极性基带系统的抗噪性能
SNR_dB = 0:0.05:10;
scal = 10.^(SNR_dB/10); %信噪比的比例形式


A_over_sigma = sqrt(scal)*sqrt(2);
double = 0.5*erfc(sqrt(scal));
single = 0.5*erfc(0.5*sqrt(scal));

figure('NumberTitle', 'off', 'Name','相同抽样电平下两种数字基带系统的抗噪声能力');
semilogy(A_over_sigma,double);
hold on;
semilogy(A_over_sigma,single);
xlabel('抽样电平/噪声均方值');
ylabel('系统误码率Pe');
grid on;
legend('双极性','单极性');

%tips:数字基带系统的抗噪性能（不考虑码间干扰，受噪声引起的误码率）与信号码元抽样电平的值与噪声均方根值（功率开方，即高斯噪声的方差开方）之比有关
%如果是理想的方波码元，功率为A


%第4-5行其实是验证了两种编码方式：相同的电平值A和噪声均方值下不同的抗噪表现，而不是相同的信噪比条件下，因为如果两个信号的SNR相同，则两个信号的电平值也不同



%----验证相同SNR下不同系统的抗噪性能（此时两种信号的电平值也不同）-----

double_2 = 0.5*erfc(sqrt(scal)/sqrt(2));
single_2 = 0.5*erfc(sqrt(scal)/2);
figure('NumberTitle', 'off', 'Name','相同SNR下两种数字基带系统的抗噪声能力');
semilogy(SNR_dB,double_2);
hold on;
semilogy(SNR_dB,single_2);
xlabel('SNR(Eb/N0)-dB');
ylabel('系统误码率Pe');
grid on;
legend('双极性','单极性');
