function [samples, PCM_seq] = PCM_generator(m, length)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Input          m--> no.of bits
%               length--> no.of samples


%Output         PCM sequence(binary)
%               Randoms samples

    samples = randi([1 (2^m -1)], length, 1);
    bin = de2bi(samples, m);
    PCM_seq = reshape(bin', 1, [])';
end