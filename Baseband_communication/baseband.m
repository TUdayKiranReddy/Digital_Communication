clc;clear;close all;

m = 6; % BIT DEPTH
M = 4; % M-ary PAM
snr = 6; % SNR 
fs = 8000; %SAMPLING RATE
tfs = 32000;
Rb = m*fs; % BIT RATE
Rs = Rb/log2(M);
len_PCM = 600; % length of PCM
upsampling_factor = 8;
fup = 1/(upsampling_factor*Rs);
A = 1; % Maximum Amplitude of PAM Symbol

t = (0:1/(upsampling_factor*0.5*Rb):((len_PCM)/Rb)-(1/(upsampling_factor*0.5*Rb)))';
T = (0:1/(upsampling_factor*0.5*Rb):((upsampling_factor*0.5*len_PCM)/Rb))';
shape = size(t);
PCM_seq = randi([0 1], len_PCM, 1);  % PCM SEQUENCE

PCM = seq_broadcast(PCM_seq, Rb, 1/(upsampling_factor*0.5*Rb));

PAM = PCM_to_PAM(PCM_seq, A);
PAM_t = PAM;

%----Transmission
PAM = seq_broadcast(PAM, Rs, fup);
%----

% Adding AWGN -- Channel
for i = 1:length(PAM)-upsampling_factor
    y_i = PAM(i:i+upsampling_factor);
    PAM(i:i+upsampling_factor) = y_i +  add_noise(y_i, snr, Rs, A);
end 
%---

%Matched Filter and sampling
for i = 1:length(PAM)/upsampling_factor
    z(((2*upsampling_factor-1 )*(i-1)) + 1:(2*upsampling_factor-1)*i) = matched_filter(PAM(upsampling_factor*(i-1) + 1:upsampling_factor*(i)), A);
    symbols(i) = z((((2*upsampling_factor-1)*(2*i-1)) + 1)/2)/(A*upsampling_factor);
    %--normalisation doing due to numerical convolution happening in digital computer
end
%-----

%--Decision Maker
for i = 1:length(symbols)
    if symbols(i) >= 0.75*A
        PAM_r(i) = A;
    elseif symbols(i) < 0.75*A && symbols(i)>=0
        PAM_r(i) = A/2;
    elseif symbols(i) < 0 && symbols(i) >= -0.75*A
        PAM_r(i) = -0.5*A;
    elseif symbols(i) < -0.75*A
        PAM_r(i) = -1*A;
    end
end
%----

%---- PAM to PCM
PCM_r = PAM_to_PCM(PAM_r, A)';
%---

%---Symbol Error Rate
SER = (sum(PAM_t ~= PAM_r')/length(PAM_t))
%--Bit Error Rate
BER = (sum(PCM_seq ~= PCM_r)/length(PCM_seq))
%---

% plot(t, pulstran(t, PAM_t', @rectpuls));hold on;
%plot(t, pulstran(t, symbols, @rectpuls));

function PAM = PCM_to_PAM(seq, B)
    PAM = zeros(length(seq)/2, 1);
    for i = 1:length(seq)/2
        if(seq((2*i - 1):2*i) == [1; 1])
            PAM(i) = B;
        elseif(seq((2*i - 1):2*i) == [1; 0])
            PAM(i) = B/2;
        elseif(seq((2*i - 1):2*i) == [0; 1])
            PAM(i) = -0.5*B;
        else
            PAM(i) = -1*B;
        end
    end
end 

function sig = seq_broadcast(seq, Rs, t_step)
    sig = repelem(seq, round(1/(Rs*t_step)));
end

function csig = add_noise(a, snr, Rs, A)
    csig = (sqrt((5*(A^2))/Rs*8)/(10^(snr*0.05)))*randn(length(a), 1);%(sqrt(A*abs(a(1)/Rs)))
end

function y_out = matched_filter(y, A)
    c = 1;  
    shape = size(y);
    m_opt = A*c*ones(shape(1), 1);
    y_out = conv(y, m_opt);
    size(y_out);
end

function sample = sampler(t, m)
    sample = m(t == (1/Rs));
end

function PCM = PAM_to_PCM(seq, A)
    for i = 1:length(seq)
        if seq(i) == A
            PCM(2*i-1:2*i) = [1 1]';
        elseif seq(i) == 0.5*A
            PCM(2*i-1:2*i) = [1 0]';
        elseif seq(i) == -0.5*A
            PCM(2*i-1:2*i) = [0 1]';
        else
            PCM(2*i-1:2*i) = [0 0]';
        end
    end
end