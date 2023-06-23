function [stat,delta,double_delta]=extract_lpcc(speech,Fs,Window_Length,No_Filter) 
% Function for computing LPCC features 
% Usage: [stat,delta,double_delta]=extract_lpcc(file_path,Fs,Window_Length,No_Filter) 
%
% Input: file_path=Path of the speech file
%        Fs=Sampling frequency in Hz
%        Window_Length=Window length in ms
%        NFFT=No of FFT bins
%        No_Filter=No of filter
%
%Output: stat=Static LPCC (Size: NxNo_Filter where N is the number of frames)
%        delta=Delta LPCC (Size: NxNo_Filter where N is the number of frames)
%        double_delta=Double Delta LPCC (Size: NxNo_Filter where N is the number of frames)

%-----------------------Reading Speech File--------------------------------
% speech=readwav(file_path,'s',-1);
%-------------------------- PRE-EMPHASIS ----------------------------------
speech = filter( [1 -0.97], 1, speech);
%---------------------------FRAMING & WINDOWING----------------------------
frame_length_inSample=(Fs/1000)*Window_Length;
framedspeech=buffer(speech,frame_length_inSample,frame_length_inSample/2,'nodelay')';
w=hamming(frame_length_inSample);
y_framed=framedspeech.*repmat(w',size(framedspeech,1),1);
lpc_coef=lpc(y_framed',No_Filter);
stat=lpcar2cc(lpc_coef,No_Filter);
delta=deltas(stat',3)';
double_delta=deltas(delta',3)';
%--------------------------------------------------------------------------