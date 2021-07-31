function [out] = lowpass_filter(f,fs,B)
%f:frequency samples
%fs:input frequency samples
%B:lowpass band
%out:output frequency samples

N = length(f);
frequency_gap = f(2)-f(1); %采样频率间隔
filter = zeros(1,N);
band = (-floor(B/frequency_gap):floor(B/frequency_gap))+floor(length(f)/2);
filter(band) = 1;
out = filter.*fs;