% fs = 32000;
% Rb = 6*fs;
% m = 4;
% Rs = Rb/log2(m);
% len = 100;
% t = 0:1/Rb:(len - 1)/Rb;
% PCM = randi([0 1], len, 1);
% stairs(t, PCM);
% %axis([0 1 -3 3]);
% %PAM = pammod(PCM, m);
% %plot(t, PAM);
% b = PCM_seq;
% l=length(b);
% b(l+1)=0;
% n=1;
% while n<=l
%     t=(n-1):1/Rb:n;
%     if b(n)==1
%         if b(n+1)==b(n)
%             y=(t<(n-0.5))+(t==n);
%         else
%             y=(t<(n-0.5));
%         end
%     else
%         if b(n+1)==1
%             y=0*(t<(n-0.5))+(t==n);
%         else
%             y=0*(t<(n-0.5));
%         end
%     end
%     n=n+1;
%     plot(t,y)
%     hold on;
%     axis([0 l -1.5 1.5]);
% end
% title('RZ');
% xlabel('Time');
% ylabel('Amplitude');
fs = 32000; %SAMPLING RATE
Rb = m*fs; % BIT RATE
Rs = Rb/log2(M);
FS = 8000;              %sample frequency
n = randi([0 256], 1, 5);   %sample data
PCM_seq = randi([0 1], len_PCM, 1)
bits = reshape( (dec2bin(n,8) - '0').', 1, [] );
%[t, encoded_bits] = 
UNRZ(PCM_seq, Rs);
%stairs(t, encoded_bits)

function UNRZ(h,Rs)
clf;
n=1;
l=length(h);
h(l+1)=1;
while n<=length(h)-1;
    t=(n-1)/Rs:1/(10*Rs):n/Rs;
if h(n) == 0
    if h(n+1)==0  
        y=(t>n/Rs);
    else
        y=(t==n/Rs);
    end
    d=plot(t,y);grid on;
    title('Line code UNIPOLAR NRZ');
    set(d,'LineWidth',2.5);
    hold on;
    axis([0 (length(h)-1)/Rs -1.5 1.5]);

else
    if h(n+1)==0
        %y=(t>n-1)-2*(t==n);
        y=(t<n/Rs)-0*(t==n/Rs);
    else
        %y=(t>n-1)+(t==n-1);
        y=(t<n/Rs)+1*(t==n/Rs);
    end
    %y=(t>n-1)+(t==n-1);
    d=plot(t,y);grid on;
    title('Line code UNIPOLAR NRZ');
    set(d,'LineWidth',2.5);
    hold on;
    axis([0 (length(h)-1)/Rs -1.5 1.5]);
 
end
n=n+1;
%pause; 
end
end
