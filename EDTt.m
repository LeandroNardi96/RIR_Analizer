function EDTt()
    global handles;
    freq_cent = handles.audio_data.MONO.filtered_data.filter.validfreq;
    dim = size(freq_cent);
    largo = dim(2);
    
    a0EDTt=zeros(1,largo);
    a1EDTt=zeros(1,largo);
    EDTt=zeros(1,largo);
    
    for i=1:largo
        RIR_median = getfield(handles.audio_data.MONO.med,strcat('m',num2str(round(freq_cent(i))))); %suavizado mediana
        RIR_median = RIR_median';
        T = length(RIR_median)/handles.audio_data.fs;
        t = 0:1/handles.audio_data.fs:T-1/handles.audio_data.fs; %vector tiempo
        [~,y1] = max(RIR_median);
        RIR_median = RIR_median(y1:end); %recorte de la senal a partir de su valor maximo (0dBFS)
        t = t(y1:end); %inicializacion del vector de tiempo en funcion a su valor maximo
        [~,xminEDTt] = min(abs(t - 0));
        t0 = t(xminEDTt);
        t_end = t0 + handles.results.Tt(i);
        [~,xmaxEDTt] = min(abs(t - t_end));
        
%EDT_time        
        xEDTt = t(xminEDTt:xmaxEDTt); %indexacion del vector de tiempo con los valores de posicion
        yEDTt = RIR_median(xminEDTt:xmaxEDTt); %indexacion del vector de amplitudes con los valores de posicion
        [a0EDTt(i),a1EDTt(i)] = LeastSquares(xEDTt,yEDTt);
        EDTt(i) = (-60 - a0EDTt(i))/a1EDTt(i);

    end
    handles.results.EDTt = EDTt;
end