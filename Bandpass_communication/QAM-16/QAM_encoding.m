function y = QAM_encoding(bin_data, len, t, up_sfac, T_sym, E_b)
    QAM_baseband = PCM_to_16QAM(bin_data, len, E_b);
    CS = sqrt(2/T_sym)*[cos((2*pi/T_sym)*t(1:4*up_sfac));sin((2*pi/T_sym)*t(1:4*up_sfac))];
    for i=1:len/4
        chunk = (4*up_sfac*(i-1) + 1):4*up_sfac*i;
        y(chunk) = QAM_baseband(i,:)*CS;
    end
end

