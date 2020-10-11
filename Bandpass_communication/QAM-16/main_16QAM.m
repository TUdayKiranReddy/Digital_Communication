clc; clear all;close all;

A = 1;
Rb = 4e3;
Rs = Rb/4;
snr = 10;
len = 10000;
up_sfac = 4;

T_b = 1/Rb;
T_sym = 1/Rb;
E_b = (0.5*A^2)/T_sym;

t_step = T_b/up_sfac;
t = [0:t_step:len*T_sym - t_step];

bin_data = randi([0 1], len, 1);
pcm = seq_broadcast(bin_data, 1/T_b, t_step);

QAM_baseband = PCM_to_16QAM(bin_data, len, E_b);
QAM_bandpass = QAM_encoding(bin_data, len, t, up_sfac, T_sym, E_b)';

power = 10*log10((10*E_b)/(T_sym));
rx = awgn(QAM_bandpass, snr, power);

z = QAM_correlator(rx, up_sfac, len ,T_sym, t);
% 
% thetha = 18.0694;%2*pi/T_sym;
% R = [cosd(thetha) -sind(thetha);sind(thetha) cosd(thetha)];

% for i =1:len/4
%     z(:, i) = R*z(:, i);
% end
% 
% z = 4*z';

QAM_symbols_decoded_PCM = QAM_ml_decoder(z, len, E_b)';

BER = sum(QAM_symbols_decoded_PCM ~= bin_data)/len


theoritical_ber = (3*qfunc(sqrt(0.8*(10^(0.1*snr)))))/16

% figure(1);
% c = 16;
% plot(t(1:c), QAM_bandpass(1:c));hold on;grid on;
% plot(t(1:c), 3*sqrt(2*E_b/T_sym)*pcm(1:c));hold on;
% plot(t(1:c), rx(1:c));


scatterplot(z');grid on;hold on;
%figure();
sE_b = sqrt(E_b)
plot(-3*sE_b, -3*sE_b, '*r');hold on;
plot(-1*sE_b, -3*sE_b, '*r');hold on;
plot(sE_b, -3*sE_b, '*r');hold on;
plot(3*sE_b, -3*sE_b, '*r');hold on;
plot(-3*sE_b, -1*sE_b, '*r');hold on;
plot(-1*sE_b, -1*sE_b, '*r');hold on;
plot(sE_b, -1*sE_b, '*r');hold on;
plot(3*sE_b, -1*sE_b, '*r');hold on;
plot(-3*sE_b, sE_b, '*r');hold on;
plot(-1*sE_b, sE_b, '*r');hold on;
plot(sE_b, sE_b, '*r');hold on;
plot(3*sE_b, sE_b, '*r');hold on;
plot(-3*sE_b, 3*sE_b, '*r');hold on;
plot(-1*sE_b, 3*sE_b, '*r');hold on;
plot(sE_b, 3*sE_b, '*r');hold on;
plot(3*sE_b, 3*sE_b, '*r');hold on;
axis([-5*sE_b 5*sE_b -5*sE_b 5*sE_b]);

function sig = seq_broadcast(seq, Rs, t_step) %For plotting Rectangular Pulse
    sig = repelem(seq, round(1/(Rs*t_step)));
end