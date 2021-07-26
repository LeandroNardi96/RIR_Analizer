function [file] = FileLoad(~,~)
    global handles;
    
    %si no existe la estructura "audio_data" se la crea y se la almacena
    %dentro de "handles"
    if isfield(handles,'audio_data')==0
         audio_data=struct;
         handles.audio_data=audio_data;
    end

    [file,path] = uigetfile('*.wav*','Seleccione una o varias RIRs','Multiselect','on');
    f = fullfile(path,file);
    
    if iscell(file)==0 && ischar(file)==0 && file==0
        uiwait(msgbox('Seleccione una o varias RIRs'));
      
    else
        
        

        % Cargado de nombres a base de datos (depende de si es 1 o varios)
        clase = class(f);
        if clase == 'char'
            number_files = 1; % defino cantidad de archivos a tratar
            file_char = char(f);                                 % fs sera unica
        elseif clase == 'cell'
            number_files = size(f,2); % cantidad de archivos a tratar
            file_char = char(f); % pasar a caracteres los nombres para que audio read los interprete

        end 
        
        %se almacena la cantidad de archivos cargados y sus nombre en la
        %estructura global "audio_data" en "handles"
        handles.audio_data.number_files = number_files;
        handles.audio_data.file_char = file_char;
    end
end