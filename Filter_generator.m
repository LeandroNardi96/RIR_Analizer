function Filter_generator(Fs,ord,kind,bandsperoctave)
%Fs: Frecuencia de sampleo.
%ord: orden del filtro.
%kind: tipo de filtro: 'oct' o 'thrdoct'.
%bandsperoctave: 1 si kind = 'oct', 3 si kind = 'thrdoct'.
clear all
F0 = 1000;
data.filter = [];
h = fdesign.octave(bandsperoctave, 'Class 0', 'N,F0', ord, F0, Fs);
F0 = validfrequencies(h); %obtiene todas las frecuencias centrales en función de una F central y normalizada (1000).
data.filter.validfreq = F0;
for i = 1:length(F0)
    h.F0 = F0(i);
    H(i) = design(h,'butter');
end
filename = strcat(kind,'filters',num2str(Fs),'.mat');
structfname = strcat(kind,'struct',num2str(Fs),'.mat');
save(filename, 'H');
save(structfname, 'data');
fvtool(H);
end