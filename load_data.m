function [EHG_data,n_sig,fs,n_samp,ADC_gain,ch_numbers] = load_data(HEADERFILE,DATAFILE)

% Učitavanje podataka iz zaglavlja

fid_header = fopen(HEADERFILE,'r');
z= fgetl(fid_header); 
HEADER_line = sscanf(z, '%*s %d %d %d',[1,3]);

n_sig = HEADER_line(1);
fs = HEADER_line(2);
n_samp = HEADER_line(3);

data_format = zeros(1,n_sig);
ADC_gain = zeros(1,n_sig);
ch_numbers = zeros(1,n_sig);
for i = 1:n_sig
    z = fgetl(fid_header);
    HEADER_line = sscanf(z, '%*s %d %f/mV %d %d %d %d %d EHG%d', [1,8]);

    data_format(i) = HEADER_line(1);
    ADC_gain(i) = HEADER_line(2);
    ch_numbers(i) = HEADER_line(8);
end
data_format = data_format(1);

fclose(fid_header);


% Učitavanje višekanalnog EHG signala

fid_data = fopen(DATAFILE,'r');

format = "uint" + num2str(data_format);
EHG_data = fread(fid_data, [n_sig, n_samp], format)';

fclose(fid_data);

end

