function ExcelExport(~,~)
    global handles;
    
    a={'Parametros/Frecuencia';'EDT';'T10';'T20';'T30';'D50';'C50';'C80';'Tt';'EDTt';'IACC'};
    b=string(handles.gui.table_results.Data);
    b=strrep(b,'.',',');
    c=[string(handles.gui.table_results.ColumnName');b];
    
    filter = {'*.xls'};
    [file, path] = uiputfile(filter);
    f = fullfile(path,file);
    
    status=xlswrite(f,[a,c]);
    
    waitbar1=waitbar(0,'Guardando...');
    
    waitbar(0.2,waitbar1,'Guardando...');
    
    waitbar(0.4,waitbar1,'Guardando...');
    
    waitbar(0.6,waitbar1,'Guardando...');
    
    waitbar(0.8,waitbar1,'Guardando...');
    
    close(waitbar1);
    
    if status==1
        msgbox('El archivo se ha guardado correctamente');
    else
        msgbox('Error al guardar el archivo');
    end
   
end