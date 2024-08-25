function [envelope_norm,envelope_norm2] = envelope_extraction(data,ANN_C)

% Dvostrano ispravljanje signala
data_sq = data.^2;

% Integracija signala primenom MA filtra - izdvajanje anvelope
order = 2e3; 
order2 = min(diff(ANN_C))/2;

b = ones(1,order)/order; b2 = ones(1,order2)/order2;
a = [1 zeros(1,order-1)]; a2 = [1 zeros(1,order2-1)];

envelope = filtfilt(b,a,data_sq);
envelope2 = filtfilt(b2,a2,data_sq);

% Normalizacija anvelope signala njenom maksimalnom vrednošću
envelope_norm = envelope./max(envelope(1:end-order));
envelope_norm2 = envelope2./max(envelope2(1:end-order2));

end

