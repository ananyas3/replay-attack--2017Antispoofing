clc
close all
clear all

%% Feature extraction for training data
Window_Length = 20;
NFFT = 512;
No_Filter = 29;

[x ,fs] = audioread('03-01-02-01-01-02-01.wav'); % Reading Audio file
[stat,delta,double_delta]=extract_lpcc(x,fs,Window_Length,No_Filter); %extracting the features

feat_lpcc = [stat(:,2:end) delta(:,2:end) double_delta(:,2:end)];