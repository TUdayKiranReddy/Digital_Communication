clc;close all;clear all;

f0 = 1000;
snr = 11;
len = 100;

A = 10;
ber = bpsk_communication(A, f0, snr, len, 20, 0)

snr = [-5:0.1:10];
A = 1/10;
f0 = 1e3;
len = 1000;
for i = 1:length(snr)
    ber_(i) = bpsk_communication(A, f0, snr(i), len, 20, 0)*0.5;
end
figure();
plot(snr, ber_);grid on;hold on;
plot(snr, qfunc(sqrt(2*(10.^(0.1*snr)))));
legend('simulated', 'Theoritical');
xlabel('SNR(dB)');
ylabel('BER');