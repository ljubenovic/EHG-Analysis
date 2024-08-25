function [data_filt] = highpass_filter(data,fs,cutoff,order)

[b, a] = butter(order,cutoff/(fs/2),'high');
data_filt = filtfilt(b,a,data);

N = size(data,1);
f =  (fs/N)*((-N/2+1):(N/2));
H_hp = freqz(b,a,f,fs);

% Prikaz amplitudskog odziva HP filtra
figure(position = [50,100,1000,200])
    plot(f,abs(H_hp),'linewidth',1)
    xlabel('f [Hz]'); ylabel('magnituda [a.u.]')
    title('Amplitudski ozdiv HP filtra')
    grid on; grid minor
    xlim([0 1])

end