function Smoothen()
    global handles;
    
    filter_freq = handles.audio_data.MONO.filtered_data.filter.validfreq; % se selecciona el 
    %vector de frecuencias extraido de las estructuras de los filtros 
    %(octava o tercios dependiendo la selección previa del usuario)
    
    h = cell(length(filter_freq),1);
    n = handles.audio_data.MONO.number_files; %cantidad de archivos cargados
    lengths = zeros(1,n);
    
    %se crean las estructuras que contendran la información de la salida de
    %hilbert, tanto en dB (hilb) como amplitud (hamp), y de la salida del filtro
    %de mediana móvil (med).
    med = struct;
    handles.audio_data.MONO.med = med;

    hilb = struct;
    handles.audio_data.MONO.hilb = hilb;

    hamp = struct;
    handles.audio_data.MONO.hamp = hamp;
  
  
    fmin=filter_freq(1); %frecuencia mínima de analisis (la mas baja del primer 
    %tercio de octavas o la primera octava)
    
    
    if handles.gui.rb1_window.Value==1 
        Wd=(1/fmin)*handles.audio_data.fs; %ventana recomendada
    else
        Wd=str2double(handles.gui.edit_window.String); %ventana personalizada
    end
    

    for i=1:length(filter_freq)
        
        for j=1:n
            %se extrae el audio mono "en crudo" de la estructa donde fue guardado
            y=getfield(handles.audio_data.MONO.filtered_data,strcat('f',num2str(round(filter_freq(i))),'_',num2str(j)));
            
            h{i}{j}=abs(hilbert(y));%transformada de hilbert
            lengths(j)=length(h{i}{j});%largo de cada vector de la salida de hilbert
        end

        c=min(lengths);

        for j=1:n
            h{i}{j}=h{i}{j}(1:c); %recorta todos los vectores para que tengan
            %el mismo largo que el que tiene la menor longitud
        end

        h1=cell2mat(h{i}); %pasa el cell a double
        h1=mean(h1,2); %se promedian todas las salidas de hilbert (cuando se carga
        %mas de un audio

        h2 = h1/max(h1); %se normaliza la salida de hilbert
        hFS =20*log10(h2); %se pasa hilbert de amplitud a dB

        mFS=movmedian(10*log10(h2.^2),Wd); %pasa la señal de salida
        %de hilbert por el filtro de mediana movil
        
        %se guardan todos los resultados en la estructura global handles
        handles.audio_data.MONO.med = setfield(handles.audio_data.MONO.med,strcat('m',num2str(round(filter_freq(i)))),mFS);
        handles.audio_data.MONO.hilb = setfield(handles.audio_data.MONO.hilb,strcat('h',num2str(round(filter_freq(i)))),hFS);
        handles.audio_data.MONO.hamp = setfield(handles.audio_data.MONO.hamp,strcat('hamp',num2str(round(filter_freq(i)))),h1);
        handles.audio_data.MONO.Wd = Wd;
        
    end
end
