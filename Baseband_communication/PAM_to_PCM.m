function PCM = PAM_to_PCM(seq, M, A)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Input          seq --> PAM signal
%               M --> M-ary PAM
%               A --> Amplituse of PAM


%Output         PCM sequence(binary)
%               Randoms samples

    n_b = log2(M);
    for i = 1:length(seq)
        x = de2bi(round((seq(i)/A + M - 1)/2), n_b);
        PCM((n_b)*(i-1)+1:n_b*i) = fliplr(x);
    end
end
