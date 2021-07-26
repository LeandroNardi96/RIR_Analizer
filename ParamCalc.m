function ParamCalc()
    global handles;   
    
    freq_cent = handles.audio_data.MONO.filtered_data.filter.validfreq;
    dim = size(freq_cent);
    largo = dim(2);
    results = zeros(4,largo);
    
    a0EDT = zeros(1,length(freq_cent));
    a1EDT = zeros(1,length(freq_cent));
    a0T10 = zeros(1,length(freq_cent));
    a1T10 = zeros(1,length(freq_cent));
    a0T20 = zeros(1,length(freq_cent));
    a1T20 = zeros(1,length(freq_cent));
    a0T30 = zeros(1,length(freq_cent));
    a1T30 = zeros(1,length(freq_cent));
    EDT = zeros(1,length(freq_cent));
    T10 = zeros(1,length(freq_cent));
    T20 = zeros(1,length(freq_cent));
    T30 = zeros(1,length(freq_cent));
    
    for i=1:largo
        y = getfield(handles.audio_data.MONO.med,strcat('m',num2str(round(freq_cent(i)))));
        y = y - max(y); %normalizo para llevar el maximo a 0, porque por cada banda quedaban desfazados y entonces calculaba mal
        y = y';

        T = length(y)/handles.audio_data.fs;
        n = 0:1/handles.audio_data.fs:T-1/handles.audio_data.fs; %vector de posicion (lo defini porque lo necesitaba, la idea es usar el vector que ya esta definido antes)
        [~,y1] = max(y);
        y = y(y1:end); %recorte de la senal a partir de su valor maximo (0dBFS)
        n = n(y1:end); %inicializacion del vector de tiempo en funcion a su valor maximo
        [~,z1] = max(y);% nueva posicion del valor maximo (1)
        [~,z] = min(abs(y - (-45)));%recorte a partir del piso de ruido medido

        amp_re  = y(z1:z);%recorte de la amplitud normalizada entre 0dBFS y -45dBFS
        vector_in = n(z1:z); %redefinicion del vector de posicion en funcion de 0dBFS y -45dBFS

        %EDT
        [~,xminEDT] = min(abs(amp_re - 0)); %posicion del primer valor proximo a 0dBFS
        [~,xmaxEDT] = min(abs(amp_re - (-10)));%posicion del primer valor proximo a -10dBFS
        xEDT = vector_in(xminEDT:xmaxEDT); %indexacion del vector de tiempo con los valores de posicion
        yEDT = amp_re(xminEDT:xmaxEDT); %indexacion del vector de amplitudes con los valores de posicion
        [a0EDT(i),a1EDT(i)] = LeastSquares(xEDT,yEDT);

        %T10
        [~,xminT10] = min(abs(amp_re - (-5))); %posicion del primer valor proximo a -10dBFS
        [~,xmaxT10] = min(abs(amp_re - (-15)));%posicion del primer valor proximo a -15dBFS
        xT10 = vector_in(xminT10:xmaxT10);%indexacion del vector de tiempo con los valores de posicion (indices)
        yT10 = amp_re(xminT10:xmaxT10);%indexacion del vector de amplitudes con los valores de posicion (indices)
        [a0T10(i),a1T10(i)] = LeastSquares(xT10,yT10);

        %T20
        [~,xminT20] = min(abs(amp_re - (-5))); %idem anteriores...
        [~,xmaxT20] = min(abs(amp_re - (-25)));
        xT20 = vector_in(xminT20:xmaxT20);
        yT20 = amp_re(xminT20:xmaxT20);
        [a0T20(i),a1T20(i)] = LeastSquares(xT20,yT20);

        %T30
        [~,xminT30] = min(abs(amp_re - (-5)));
        [~,xmaxT30] = min(abs(amp_re - (-35)));
        xT30 = vector_in(xminT30:xmaxT30);
        yT30 = amp_re(xminT30:xmaxT30);
        [a0T30(i),a1T30(i)] = LeastSquares(xT30,yT30);

        %calculos

        EDT(i) = (-60 - a0EDT(i))/a1EDT(i);
        T10(i) = (-60 - a0T10(i))/a1T10(i);
        T20(i) = (-60 - a0T20(i))/a1T20(i);
        T30(i) = (-60 - a0T30(i))/a1T30(i);
        results(1:4,i) = [EDT(i),T10(i),T20(i),T30(i)]';
    end

    handles.results.TR = results;    
end