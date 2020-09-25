function y_out = matched_filter(y, A)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Input          y --> Recieved Signal
%               A --> Amplitude of modulated Pulse Amplitude Modulated
%               signal


%Output         PCM sequence(binary)
%               Randoms samples

    c = 1;  
    shape = size(y);
    m_opt = A*c*ones(shape(1), 1);
    y_out = conv(y, m_opt);
    size(y_out);
end