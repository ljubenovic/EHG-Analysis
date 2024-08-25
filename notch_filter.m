function [data_filt] = notch_filter(data,fs,order)

[b, a] = butter(order, [49.5/(fs/2) 50.5/(fs/2)], 'stop');
data_filt = filtfilt(b,a,data);

N = size(data,1);
f =  (fs/N)*((-N/2+1):(N/2));
H_hp = freqz(b,a,f,fs);
H_n50 = freqz(b,a,f,fs);

% Prikaz amplitudskog odziva notch filtra na 50 Hz
figure(position = [50,100,1000,200])
    plot(f,abs(H_n50),'linewidth',1)
    xlabel('f [Hz]'); ylabel('magnituda [a.u.]')
    title('Amplitudski ozdiv notch filtra na 50 Hz')
    grid on; grid minor
    xlim([0 fs/2])

end

