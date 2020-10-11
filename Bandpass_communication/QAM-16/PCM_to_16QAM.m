function symbols = PCM_to_16QAM(bin_data, len, E_b)
    rt_en = sqrt(E_b);
    for i = 1:len/4
        if(bin_data(4*(i-1)+1:4*i) == [0;0;0;0])
            symbols(i, 1:2) = [-3*rt_en 3*rt_en];
        elseif(bin_data(4*(i-1)+1:4*i) == [0;0;0;1])
            symbols(i, 1:2) = [-1*rt_en 3*rt_en];
        elseif(bin_data(4*(i-1)+1:4*i) == [0;0;1;1])
            symbols(i, 1:2) = [rt_en 3*rt_en];
        elseif(bin_data(4*(i-1)+1:4*i) == [0;0;1;0])
            symbols(i, 1:2) = [3*rt_en 3*rt_en];
        elseif(bin_data(4*(i-1)+1:4*i) == [0;1;0;0])
            symbols(i, 1:2) = [-3*rt_en rt_en];        
        elseif(bin_data(4*(i-1)+1:4*i) == [0;1;0;1])
            symbols(i, 1:2) = [-1*rt_en rt_en];
        elseif(bin_data(4*(i-1)+1:4*i) == [0;1;1;1])
            symbols(i, 1:2) = [rt_en rt_en];
        elseif(bin_data(4*(i-1)+1:4*i) == [0;1;1;0])
            symbols(i, 1:2) = [3*rt_en rt_en];
        elseif(bin_data(4*(i-1)+1:4*i) == [1;1;0;0])
            symbols(i, 1:2) = [-3*rt_en -1*rt_en];
        elseif(bin_data(4*(i-1)+1:4*i) == [1;1;0;1])
            symbols(i, 1:2) = [-1*rt_en -1*rt_en];
        elseif(bin_data(4*(i-1)+1:4*i) == [1;1;1;1])
            symbols(i, 1:2) = [rt_en -1*rt_en];        
        elseif(bin_data(4*(i-1)+1:4*i) == [1;1;1;0])
            symbols(i, 1:2) = [3*rt_en -1*rt_en];
        elseif(bin_data(4*(i-1)+1:4*i) == [1;0;0;0])
            symbols(i, 1:2) = [-3*rt_en -3*rt_en];
        elseif(bin_data(4*(i-1)+1:4*i) == [1;0;0;1])
            symbols(i, 1:2) = [-1*rt_en -3*rt_en];        
        elseif(bin_data(4*(i-1)+1:4*i) == [1;0;1;1])
            symbols(i, 1:2) = [rt_en -3*rt_en];
        else
            symbols(i, 1:2) = [3*rt_en -3*rt_en];
        end
    end
end