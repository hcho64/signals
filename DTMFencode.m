function [x,fs] = DTMFencode(key,duration,weight,fs)
%[x,fs] = DTMFencode(key,duration,weight,fs)
%
%This function outputs a sound waveform generated by pressing the 
% corresponding key
%
%Parameters:
%key      =	a character corresponding to one of twelve possible keys
%duration = desired duration of the signal
%weight   =	1x2 vector with desired weight of low and high frequency
%fs       =	sampling rate in Hz, values below 3000Hz should not be accepted
%
%Defaults:
%	duration = 200
%	weight = [1 1]
%   fs = 8000

%% Set default variables
if nargin == 1
    dur = 200;
    wgt = [1 1];
    fs = 8000;
else 
    dur = duration;
    wgt = weight;
    freq = fs;
    if freq < 3000
        error("Sampling rate must be at least 3000Hz.");
    end
end

N = dur * fs / 1000;

%% Set high frequency
hf = 0;
if key == '1' || key == '4' || key == '7' || key == '*'
    hf = 1209;
elseif key == '2' || key == '5' || key == '8' || key == '0'
    hf = 1336;
elseif key == '3' || key == '6' || key == '9' || key == '#'
    hf = 1477;
end

%% Set low frequency
lf = 0;
if key == '1' || key == '2' || key == '3'
    lf = 697;
elseif key == '4' || key == '5' || key == '6'
    lf = 770;
elseif key == '7' || key == '8' || key == '9'
    lf = 852;
elseif key == '*' || key == '0' || key == '#'
    lf = 941;
end
lf_signal = wgt(1) * sin(2*pi*lf*(0:N-1)/fs);
hf_signal = wgt(2) * sin(2*pi*hf*(0:N-1)/fs);
S = lf_signal+hf_signal;

Y = fft(S);
L = length(S);
P2 = abs(Y/L);
P1 = P2(1:L/2+1);
P1(2:end-1) = 2*P1(2:end-1);
f = fs*(0:(L/2))/L;

x_axis = linspace(0, dur, length(S));
subplot(2,1,1)
plot(x_axis, S);

subplot(2,1,2);
plot(f,P1);
