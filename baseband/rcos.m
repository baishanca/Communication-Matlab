function [ht] = rcos(a,Tb,t)
temp = 10^(-5); %防止分母为零
ht = sinc(t/Tb).*(cos(pi*a/Tb*t)+temp)./(1-4*a^2/Tb^21*t.^2+temp);
ht = sinc(t/Tb).*(cos(pi*a/Tb*t))./(1-4*a^2/Tb^21*t.^2);
end

