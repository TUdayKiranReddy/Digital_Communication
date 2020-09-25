function PAM = PCM_to_PAM(seq, M, B)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Input          M--> M-ary PAM
%               B--> Amplitude of M-ary


%Output         Pulse Amplitude Modulated signal

    n_b = log2(M);
    for i = 1:length(seq)/n_b
        m = 1 + bi2de(fliplr(seq((n_b)*(i-1)+1:n_b*i)'));
        PAM(i) = B*(2*m - 1 - M);
    end
    PAM = PAM';
end