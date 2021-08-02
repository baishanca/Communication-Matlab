function [out] = zeropad(ser,N)
len = length(ser);
out = zeros(N,len);
out(1,:) = ser;
out = reshape(out,1,N*len);
