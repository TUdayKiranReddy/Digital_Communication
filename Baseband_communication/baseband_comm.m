function [samples_r, BER, PCM_SER, PAM_SER] = baseband_comm(m, M, fs, length_of_samples, snr, upsampling_factor, plt)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%% This function generates random signal and simulates the baseband
%%%%%% communication at given specifications.

%Input    m -->BIT DEPTH
%         M -->M-ary PAM
%         snr-->SNR 
%         fs-->SAMPLING RATE

%Output   samples_r---> Recieved signal
%         BER---------> Bit Error Rate
%         PCM_SER-----> Signals Symbol Error Rate
%         PAM_SER-----> M-ary PAM's Symbol Error Rate


    Rb = m*fs; % BIT RATE
    Rs = Rb/log2(M);
    len_PCM = m*length_of_samples; % length of PCM
    fup = 1/(upsampling_factor*Rs);
    A = sqrt(Rs); % Maximum Amplitude of PAM Symbol
    
    if nargin > 6
        isplot = plt;
    else
        isplot = 1;
    end
    
    t = (0:1/(upsampling_factor*0.5*Rb):((len_PCM)/Rb)-(1/(upsampling_factor*0.5*Rb)))';

    [samples, PCM_seq] = PCM_generator(m, length_of_samples);
    PCM = seq_broadcast(PCM_seq, Rb, 1/(upsampling_factor*0.5*Rb));

    PAM = PCM_to_PAM(PCM_seq, M, A);
    PAM_t = PAM;

    %----Transmission
    PAM = seq_broadcast(PAM, Rs, fup);
    %----
    
    %---Adding AWGN -- Channel
    for i = 1:length(PAM)-upsampling_factor
        y_i = PAM(i:i+upsampling_factor);
        PAM_noisy(i:i+upsampling_factor) = y_i +  add_noise(y_i, snr, Rs, A);
    end 
    PAM_noisy = PAM_noisy'; 
    %---
    
    %----Matched Filter and sampling
    for i = 1:length(PAM_noisy)/upsampling_factor
        z(((2*upsampling_factor-1 )*(i-1)) + 1:(2*upsampling_factor-1)*i) = matched_filter(PAM_noisy(upsampling_factor*(i-1) + 1:upsampling_factor*(i)), A);
        symbols(i) = z((((2*upsampling_factor-1)*(2*i-1)) + 1)/2)/(A*upsampling_factor);
        %--normalisation doing due to numerical convolution happening in digital computer
    end
    symbols = symbols';
    %-----

    %--Decision Maker MAP
    for i = 1:length(symbols)
        %for m = 1:M

        if symbols(i) >= 2*A
            PAM_r(i) = 3*A;
        elseif symbols(i) < 2*A && symbols(i)>=0
            PAM_r(i) = A;
        elseif symbols(i) < 0 && symbols(i) >= -2*A
            PAM_r(i) = -1*A;
        elseif symbols(i) < -2*A
            PAM_r(i) = -3*A;
        end
    end

    PAM_r = PAM_r';
    %----

    %---- PAM to PCM
    PCM_r = PAM_to_PCM(PAM_r, M, A)';
    %---

    %---Reconstruct samples from PCM_recived
    samples_r = PCM_to_samples(PCM_r', m)';

    %---Symbol Error Rate
    PCM_SER = (sum(samples_r ~= samples)/length(samples));
    PAM_SER = (sum(PAM_t ~= PAM_r)/length(PAM_t));

    
    %----

    %--Bit Error Rate
    BER = (sum(PCM_seq ~= PCM_r)/length(PCM_seq));
    %---
    
    %--------Plotting
    if isplot
        c = 100;
        figure(1);
        plot(t(1:c), PAM(1:c));hold on;
        title('PAM');
        plot(t(1:c), PAM_noisy(1:c));
        title('PAM through Channel');
        saveas(gcf,'./Plots/PAM.png');
        
        figure(2);
        plot(z(1:c));
        title('Output of Matched Filter');
        saveas(gcf,'./Plots/Matched_filter.png');
        
        figure(3);
        PAM_r_rect = seq_broadcast(PAM_r', Rb, 1/(upsampling_factor*Rb));
        plot(t(1:c), PAM_r_rect(1:c), 'b');
        title('Symbols after MAP Decoder');
        saveas(gcf,'./Plots/Output_of_MAP_Decoder.png');
        
        figure(4);
        plot(samples(1:c));hold on;
        plot(samples_r(1:c));
        title('Comparing tx and rx signal');
        legend('Transmitted', 'Received');
        saveas(gcf,'./Plots/tx_vs_rx.png')
        hold off;
    end
    %-----
end

function sig = seq_broadcast(seq, Rs, t_step) %For plotting Rectangular Pulse
    sig = repelem(seq, round(1/(Rs*t_step)));
end

function csig = add_noise(a, snr, Rs, A)    % Adding AWGN 
    csig = (sqrt((5*(A^2)))/(10^(snr*0.05)))*randn(length(a), 1);
end



function samples = PCM_to_samples(PCM_seq, m)   % Converting PCM to Samples
    for i = 1:(length(PCM_seq)/m)
        PCM_seq((m*(i-1) +1):m*i);
        samples(i) = bi2de(PCM_seq((m*(i-1) +1):m*i));
    end
end 
