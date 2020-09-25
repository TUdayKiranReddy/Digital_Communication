clc;clear all;close all;

%-----Question 4
[~, BER, PCM_SER, PAM_SER] = baseband_comm(6, 4, 8000, 100, 6, 4)
%------

%----For checking how metrics vary with change in AWGN noise
snr = -5:0.5:15;
for i = 1:length(snr)
    [~, ber(i), pcm_ser(i), pam_ser(i)] = baseband_comm(6, 4, 8000, 100, snr(i), 4, 0);
end

figure();
plot(snr, ber);hold on;grid on;
plot(snr, pcm_ser);hold on;
plot(snr, pam_ser);
title('Variation in SNR');
legend('BER', 'PCM SER', 'PAM SER');
saveas(gcf,'./Plots/VARIATION_OF_SNR.png');
%-----