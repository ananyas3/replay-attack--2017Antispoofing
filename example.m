clc
close all
clear all

[x ,fs] = audioread('D_1000001.wav');

%% Feature extraction for training data
Window_Length = 20;
NFFT = 512;
No_Filter = 29;
% No_Filter_lfcc = 30;

[stat,delta,double_delta]=extract_mfcc(x,fs,Window_Length,NFFT,No_Filter) ;

% load filterbank
% f=(fs/2)*linspace(0,1,NFFT/2+1);
% filbandwidthsf=linspace(min(f),max(f),No_Filter+2);
% filbandwidthsf = filbandwidthsf(31);
% ticks = [0:8000];
% figure;plot(filterbank); xlabel('Frequency (kHz)');xticks(ticks);axis('xy');