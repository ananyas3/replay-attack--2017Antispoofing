function [stat,delta,double_delta]=extract_mfcc(speech,Fs,Window_Length,NFFT,No_Filter) 
% Function for computing MFCC features 
% Usage: [stat,delta,double_delta]=extract_mfcc(file_path,Fs,Window_Length,No_Filter) 
%
% Input: file_path=Path of the speech file
%        Fs=Sampling frequency in Hz
%        Window_Length=Window length in ms
%        NFFT=No of FFT bins
%        No_Filter=No of filter
%
%Output: stat=Static MFCC (Size: NxNo_Filter where N is the number of frames)
%        delta=Delta MFCC (Size: NxNo_Filter where N is the number of frames)
%        double_delta=Double Delta MFCC (Size: NxNo_Filter where N is the number of frames)
%

% speech=readwav(file_path,'s',-1);
%rng('default');
%speech=speech+randn(size(speech))*eps;                           %dithering
%-------------------------- PRE-EMPHASIS ----------------------------------
speech = filter( [1 -0.97], 1, speech);
%---------------------------FRAMING & WINDOWING----------------------------
frame_length_inSample=(Fs/1000)*Window_Length;
framedspeech=buffer(speech,frame_length_inSample,frame_length_inSample/2,'nodelay')';
w=hamming(frame_length_inSample);
y_framed=framedspeech.*repmat(w',size(framedspeech,1),1);
%--------------------------------------------------------------------------
f=(Fs/2)*linspace(0,1,NFFT/2+1);
fmel=2595*log10(1+f./700); % CONVERTING TO MEL SCALE
fmelmax=max(fmel);
fmelmin=min(fmel);
filbandwidthsmel=linspace(fmelmin,fmelmax,No_Filter+2);
filbandwidthsf=700*(10.^(filbandwidthsmel/2595)-1);
fr_all=(abs(fft(y_framed',NFFT))).^2;
fa_all=fr_all(1:(NFFT/2)+1,:)';
filterbank=zeros((NFFT/2)+1,No_Filter);
for i=1:No_Filter
    filterbank(:,i)=trimf(f,[filbandwidthsf(i),filbandwidthsf(i+1),...
        filbandwidthsf(i+2)]);
end
% plot(f,filterbank); xlabel('Frequency (Hz)');%xticks([0:1:8])
filbanksum=fa_all*filterbank(1:end,:);
%-------------------------Calculate Static Cepstral------------------------
t=dct(log10(filbanksum'+eps));
t=(t(1:No_Filter,:));
stat=t'; 
delta=deltas(stat',3)';
double_delta=deltas(delta',3)';
%--------------------------------------------------------------------------