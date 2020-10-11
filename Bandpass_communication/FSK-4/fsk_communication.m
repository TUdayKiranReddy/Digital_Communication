function ber = fsk_communication(A, f0, len, snr, up_sfac, plt)
    T_sym = 1/f0;
    E_b = 0.5*T_sym*(A^2);
    t_step = ((T_sym)/up_sfac);
    t = (0:t_step:(len*T_sym-t_step))';
    
    if nargin > 5
        isplot = plt;
    else
        isplot = 1;
    end
    rng(2);
    bin_data = randi([0 1], len, 1);
    pcm = seq_broadcast(bin_data, 1/T_sym, t_step);

    s = fsk_encoding(bin_data, len, t, T_sym/t_step, T_sym, E_b);

%     power = 10*log10(2*E_b/T_sym);
%     tx = awgn(s, snr, power);
%     tx = awgn(s, snr);

    for i = 1:(len/2)
        chunk = (2*up_sfac*(i-1) + 1):2*up_sfac*(i);
        x = conv(tx(chunk), sqrt(2/T_sym)*cos((2*(pi/T_sym))*t(chunk)))/(4*up_sfac);
        y(1) = x(2*up_sfac);
        x = conv(tx(chunk), sqrt(2/T_sym)*cos((2*(pi/T_sym)+ pi/T_sym)*t(chunk)))/(4*up_sfac);
        y(2) = x(2*up_sfac);
        x = conv(tx(chunk), sqrt(2/T_sym)*cos((2*(pi/T_sym)+ 2*pi/T_sym)*t(chunk)))/(4*up_sfac);
        y(3) = x(2*up_sfac);
        x = conv(tx(chunk), sqrt(2/T_sym)*cos((2*(pi/T_sym)+ 3*pi/T_sym)*t(chunk)))/(4*up_sfac);
        y(4) = x(2*up_sfac);
        z(i, 1:4) = y;
    end
    
    z = z';
    sqrt(E_b);
    symbols = fsk_ml_decoder(z, sqrt(E_b));
    bit_r = reshape(symbols, [], 1);
    ber = sum(bit_r ~= bin_data)/len;

    if isplot
        c= 10*up_sfac;
        figure(1);
        plot(t(1:c), s(1:c));hold on;
        plot(t(1:c), pcm(1:c));
        title('4-FSK Encoding');

        figure(2);
        % c = 500;
        plot(t(1:c), s(1:c));hold on;
        plot(t(1:c), pcm(1:c));
        plot(t(1:c), tx(1:c));
        title('Channel');
    end
end

function sig = seq_broadcast(seq, Rs, t_step) %For plotting Rectangular Pulse
    sig = repelem(seq, round(1/(Rs*t_step)));
end