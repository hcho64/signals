function [key,fs] = DTMFdecode()
%[key,fs] = DTMFdecode(filename)
%
%This function decodes an audio signal into the corresponding key.
%
%Parameters:
%filename = audio signal
%
%Defaults:
%	duration = 200
%	weight = [1 1]
%   fs = 8000

% [S, fs] = audioread(filename);

N = 200 * 8000/1000;
fs = 8000;
lf_signal = sin(2*pi*770*(0:N-1)/fs);
hf_signal = sin(2*pi*1336*(0:N-1)/fs);
S = lf_signal+hf_signal;

Y = fft(S);
L = length(S);
P2 = abs(Y/L);
P1 = P2(1:L/2+1);
P1(2:end-1) = 2*P1(2:end-1);
f = fs*(0:(L/2))/L;

% x_axis = linspace(0, dur, length(S));
% subplot(2,1,1)
% plot(x_axis, S);

%subplot(2,1,2);
plot(f,P1);

max1 = -inf;
max2 = -inf;

for k = 1:length(P1)
    if P1(k) > max1 && P1(k) > max2
        max2 = max1;
        max1 = k;
    elseif P1(k) < max1 && P1(k) > max2
        max2 = k;
    end
end

max1
max2


