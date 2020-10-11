function symbols = QAM_ml_decoder(z, len, E_b)
    constelation = sqrt(E_b)*([-3 -1 1 3 -3 -1 1 3 -3 -1 1 3 -3 -1 1 3; 3 3 3 3 1 1 1 1 -1 -1 -1 -1 -3 -3 -3 -3]);
    for i = 1:len/4
        [~, idx] = min(vecnorm(z(:, i) - constelation));
        if(idx == 1)
            symbols((4*(i-1) +1):4*i) = [0;0;0;0];
        elseif(idx == 2)
            symbols((4*(i-1) +1):4*i) = [0;0;0;1];
        elseif(idx == 3)
            symbols((4*(i-1) +1):4*i) = [0;0;1;1];
        elseif(idx == 4)
            symbols((4*(i-1) +1):4*i) = [0;0;1;0];
        elseif(idx == 5)
            symbols((4*(i-1) +1):4*i) = [0;1;0;0];
        elseif(idx == 6)
            symbols((4*(i-1) +1):4*i) = [0;1;0;1];
        elseif(idx == 7)
            symbols((4*(i-1) +1):4*i) = [0;1;1;1];
        elseif(idx == 8)
            symbols((4*(i-1) +1):4*i) = [0;1;1;0]; 
        elseif(idx == 9)
            symbols((4*(i-1) +1):4*i) = [1;1;0;0];
        elseif(idx == 10)
            symbols((4*(i-1) +1):4*i) = [1;1;0;1];
        elseif(idx == 11)
            symbols((4*(i-1) +1):4*i) = [1;1;1;1];
        elseif(idx == 12)
            symbols((4*(i-1) +1):4*i) = [1;1;1;0];   
        elseif(idx == 13)
            symbols((4*(i-1) +1):4*i) = [1;0;0;0];
        elseif(idx == 14)
            symbols((4*(i-1) +1):4*i) = [1;0;0;1];
        elseif(idx == 15)
            symbols((4*(i-1) +1):4*i) = [1;0;1;1];
        elseif(idx == 16)
            symbols((4*(i-1) +1):4*i) = [1;0;1;0];               
        end
    end
end