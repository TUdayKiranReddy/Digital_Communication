function symbols = fsk_ml_decoder(z, Amplitude)
    [~, n] = size(z);
    points = Amplitude*eye(4);
    for i = 1:n
        [~, j] = min(vecnorm(points - z(:,i)));
        if(j == 1)
            symbols(1:2, i) = [0 0];
        elseif(j == 2)
            symbols(1:2, i) = [0 1];
        elseif(j == 3)
            symbols(1:2, i) = [1 1];
        elseif(j == 4)
            symbols(1:2, i) = [1 0];
        end
    end
end