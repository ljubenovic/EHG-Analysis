function [EHG_denoised] = EMD_denoising(EHG,fs)

% Izdvajanje intrinsic mode funkcija
[IMF,residual,info] = emd(EHG');

N = size(EHG,1);
t = 0:1/fs:(N-1)/fs;

% Prikaz IMF-ova
for i = 1:length(IMF(1,:))
    figure(position=[50 100 1000 100])
        plot(t,IMF(:,i))
        xlabel('t [s]')
        title(num2str(i) + ". IMF")
        xlim([0 10])
        grid on
end

% Prikaz reziduala
figure(position=[50 100 1000 100])
    plot(t,residual)
    xlabel('t [s]')
    title('residual')
    xlim([0 10])
    grid on

% Odšumljivanje EHG signala uklanjanjem visokofrekventnih modova
EHG_denoised = sum(cat(2,IMF(:,5:end)),2) + residual;

end

