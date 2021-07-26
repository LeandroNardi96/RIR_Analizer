function Tt()
global handles;
    freq_cent = handles.audio_data.MONO.filtered_data.filter.validfreq;
    dim = size(freq_cent);
    largo = dim(2);
    Tt=zeros(1,largo);
    
    for i=1:largo
        RIR_median = getfield(handles.audio_data.MONO.med,strcat('m',num2str(round(freq_cent(i))))); %suavizado mediana
        RIR = getfield(handles.audio_data.MONO.hilb,strcat('h',num2str(round(freq_cent(i))))); %envolvente
        RIR_out = RIR - RIR_median; %obtencion RIR outlier
        edf = normalize(cumsum(RIR_out,'reverse'),'range'); %Echo Density Function
        [~,Tt_index] = min(abs(edf - 1)); %calculo de indice cuando edf es 1 (se carga el "capacitor")
        T = length(RIR_median)/handles.audio_data.fs;
        t = 0:1/handles.audio_data.fs:T-1/handles.audio_data.fs; %vector tiempo
        Tt(i) = t(Tt_index); %calculo del Tt
    end
    
    handles.results.Tt = Tt;
end