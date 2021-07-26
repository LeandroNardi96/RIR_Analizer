function C50_C80_D50()
    global handles;
    
    freq_cent = handles.audio_data.MONO.filtered_data.filter.validfreq; %se obtienen los valores de las freq centrales
    dim = size(freq_cent);
    largo = dim(2);
    z50=zeros(1,largo);
    C80=zeros(1,largo);
    
    for i=1:largo
        y = getfield(handles.audio_data.MONO.hamp,strcat('hamp',num2str(round(freq_cent(i))))); %vector de hilbert (envolvente)
        T = length(y)/handles.audio_data.fs; 
        t = 0:1/handles.audio_data.fs:T-1/handles.audio_data.fs; %vector de tiempo
        H1 = y;
        [~,y1] = max(H1);
        H1 = H1(y1:end); %recorte de la senal a partir de su valor maximo (0dBFS)
        t = t(y1:end);
        [~,t0] = min(abs(t - 0));
        [~,t2] = min(abs(t - T-1/handles.audio_data.fs));
        a = t(t0); %Indice de 0 s
        b50 = a + 0.05; %indice de 50 ms 
        b80 = a + 0.08; %indice de 80 ms
        [~,t50] = min(abs(t - b50)); %valor más proximo del indice de amplitud asociaco a 50 ms 
        [~,t80] = min(abs(t - b80)); %valor más proximo del indice de amplitud asociaco a 80 ms 
        h = H1.^2; 
        y50 = h(t0:t50); %redefinicion del vector de amplitud al cuadrado hasta 50 ms
        y80 = h(t0:t80); %redefinicion del vector de amplitud al cuadrado hasta 80 ms
        y2 = h(t0:t2); %redefición del vector del valor max hasta el final
        h50 = trapz(y50); %calculo de la integral por medio de trapecio simple
        h80 = trapz(y80);
        h_c80 = trapz(h(t80:t2)); %redeficion del vector de 80 ms al final y cálculo d ela integral
        h2 = trapz(y2);
        D50 = h50/h2; %calculo D50
        z50(i) = D50;
        
        C80_aux = 10*log10(h80/h_c80); %calculo C80
   
        C80(i) = C80_aux;
    end
    
    C50 = zeros(size(z50));
    for i=1:length(z50)
        C50(i) = 10*log10(z50(i)/(1-z50(i))); %se calcula el C50 mediante una expresión equivalente del D50
    end
    handles.results.D50 = z50;
    handles.results.C50 = C50;
    handles.results.C80 = C80;

end
