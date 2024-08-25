function [ANN_C,ind_C,ANN_fm,ind_fm] = load_anottations(ANNFILE,fs,ind_start)

% Učitavanje datoteke sa anotacijama

ANN_struct = load(ANNFILE);
ANN_timestamps = ANN_struct.ann;
ANN_type = ANN_struct.type;

% Labele dostupnih anotacija: 'C' i 'fm'
% 'C' - Contraction
% 'fm' - Foetal movement

ANN_C = []; ANN_fm = [];
ind_C = 1; ind_fm = 1;

for i = 1:length(ANN_timestamps)
    if ANN_type{i} == "C"
        ANN_C(ind_C) = ANN_timestamps(i) - ind_start + 1;
        disp("Kontrakcija: " + round(ANN_C(ind_C)/fs,1) + " s")
        ind_C = ind_C + 1;
    end
    if ANN_type{i} == "fm"
        ANN_fm(ind_fm) = ANN_timestamps(i) - ind_start + 1;
        disp("Pokret fetusa: " + round(ANN_fm(ind_fm)/fs,1) + " s")
        ind_fm = ind_fm + 1;
    end
end

end

