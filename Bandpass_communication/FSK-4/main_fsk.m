clc; clear all; close all;

A = 1;
f0 = 1e3;

len = 1000;
snr = 6;
up_sfac = 20;

ber = fsk_communication(A, f0, len, snr, up_sfac, 0);


SNR = [-5:0.1:10];

for i = 1:length(SNR)
    BER(i) = fsk_communication(A, f0, len, SNR(i), up_sfac, 0);
end

plot(SNR, BER);grid on;hold on;
plot(SNR, theoritical_ber(SNR));
legend('Simulated', 'Theoritical');
xlabel('SNR');
ylabel('BER');

function ber = theoritical_ber(snr)
        ber = 0.75*qfunc(sqrt(2*(10.^(0.1*snr))));
end