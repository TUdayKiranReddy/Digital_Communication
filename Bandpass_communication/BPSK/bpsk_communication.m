function ber = bpsk_communication(A, f0, snr, len, up_sfac, plt)
    T_sym = 1/f0;
    E_b = (A^2)*0.5*T_sym;
    t_step = ((T_sym)/up_sfac);
    t = (0:t_step:(len*T_sym-t_step))';
    
    if nargin > 4
        isplot = plt;
    else
        isplot = 1;
    end
    
    rng(1);
    bin_data = randi([0 1], len, 1);
    psi = sqrt(2/T_sym)*cos(2*pi*f0*t);
    pcm = seq_broadcast(bin_data, 1/T_sym, t_step);
    pcm_t = sqrt(E_b)*(2*pcm -1);

    tx = pcm_t.*psi;
    power = 10*log(E_b/T_sym);

    %tx_noisy = tx + add_noise(E_b, snr, f0, tx);
    
    %tx_noisy = awgn(tx, snr, power);
    tx_noisy = awgn(tx, snr);


    for i = 1:len
        chunk = ((T_sym/t_step)*(i-1) + 1):(i*T_sym/t_step);
        correlator = conv(tx_noisy(chunk), sqrt(2/T_sym)*cos(2*pi*f0*t(chunk)));
        r(i) = correlator(length(chunk));
    end
    r = t_step*r'/(2*T_sym);
    z = r >0;
    
%     figure();
%     plot(r(r>0),0, '*b');grid on;hold on;
%     plot(r(r<0),0, '*r');hold on;
%     plot(sqrt(E_b), 0, 'r*');hold on;
%     plot(-1*sqrt(E_b), 0, 'b*');

    if isplot
        figure(1);
        c =500;
        plot(t(1:c), tx(1:c));hold on;
        plot(t(1:c), pcm(1:c))
        plot(t(1:c), tx_noisy(1:c));
        title('Noisy Channel');

        figure();
        plot(z(1:c/10));hold on;
        plot(bin_data(1:c/10));
        title('tx vs rx');
    end

    ber = (sum(z ~= bin_data)/len);
end

function sig = seq_broadcast(seq, Rs, t_step) %For plotting Rectangular Pulse
    sig = repelem(seq, round(1/(Rs*t_step)));
end

function s = bpsk_encoding(pcm_seq, f0, E_b, t)
    s = (2*pcm_seq - 1)*sqrt(2*E_b*f0).*cos(2*pi*f0*t + pi*2*pcm_seq);
end
function csig = add_noise(E_b, snr, f0, s)    % Adding AWGN 
    csig = sqrt(1/(2*(10^(snr*0.1))))*randn(length(s), 1);
end