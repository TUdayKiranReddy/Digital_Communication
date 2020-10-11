function  s = fsk_encoding(bin_data, len, t, upsfac, T_sym, E_b)
    for i = 1:len/2
        if(bin_data((2*(i-1)+1):(2*i)) == [0;0])
            s(( 2*upsfac*(i-1) + 1):2*upsfac*i) = sqrt(E_b*2/T_sym)*cos((2*(pi/T_sym))*t(((2*upsfac*(i-1) + 1):2*upsfac*i)));
        elseif (bin_data((2*(i-1)+1):(2*i)) == [0;1])
            s((2*upsfac*(i-1) + 1):2*upsfac*i) = sqrt(E_b*2/T_sym)*cos((2*(pi/T_sym) + pi/T_sym)*t(((2*upsfac*(i-1) + 1):2*upsfac*i)));
        elseif (bin_data((2*(i-1)+1):(2*i)) == [1;1])
            s((2*upsfac*(i-1) + 1):2*upsfac*i) = sqrt(E_b*2/T_sym)*cos((2*(pi/T_sym) + 2*pi/T_sym)*t(((2*upsfac*(i-1) + 1):2*upsfac*i)));
        elseif (bin_data((2*(i-1)+1):(2*i)) == [1;0])
            s((2*upsfac*(i-1) + 1):2*upsfac*i) = sqrt(E_b*2/T_sym)*cos((2*(pi/T_sym) + 3*pi/T_sym)*t(((2*upsfac*(i-1) + 1):2*upsfac*i)));
        end
    end
    s = s';
end