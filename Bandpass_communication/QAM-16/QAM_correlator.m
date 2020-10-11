function z = QAM_correlator(y, up_sfac, len, T_sym, t)
    for i =1:len/4
        chunk = (4*up_sfac*(i-1) + 1):4*up_sfac*i;
        time = [0:T_sym/(4*up_sfac):T_sym]';
        x = conv(y(chunk), cos((2*pi/T_sym)*t(chunk)))/(2*up_sfac);
        z(1, i) = x(4*up_sfac)/sqrt(2/T_sym);
        x = conv(y(chunk), sin((2*pi/T_sym)*t(chunk)))/(2*up_sfac);
        z(2, i) = x(4*up_sfac)/sqrt(2/T_sym);
    end
    z = -z;
    temp = z(1, :);
    z(1, :) = z(2, :);
    z(2, :) = temp;
end