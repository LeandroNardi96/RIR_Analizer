function PinkNoise(hObject,~,tO,dO,~)
    global folder;

    t = str2double(tO.String); % Pasar el objeto que ingrese en el campo, a string -> double
    d = str2double(dO.String);
        if(isnan(t))
            msgbox('Se debe asignar un tiempo de duracion','ERROR');
        else
            if(isnan(d))
                msgbox('El tiempo de delay debe ser un numero entero','ERROR');
            else
                Nx = (t*100000)/2.2676;  % numero de muestras que hay que sintetizar asociado al tiempo que quiero que dure el ruido
                Nx = int64(Nx);           %transformacion del numero real a entero (64 bits)
                B = [0.049922035 -0.095993537 0.050612699 -0.004408786];
                A = [1 -2.494956002 2.017265875 -0.522189400];        %A y B son los coeficientes del filtro 1/f (esta asociado a la funcion de transferencia)
                nT60 = round(log(1000)/(1-max(abs(roots(A)))));      % estimacion del periodo transitorio del filtro
                v = randn(1,Nx+nT60);  % generacion del ruido blanco
                p = filter(B,A,v);     % se aplica el filtro 1/f

                p = p(nT60+1:end);     % eliminacion del periodo transitorio del filtro

                %Guardado de audio .wav
                root = cd;
                cd(folder);
                cd('raw_files');
                    
                if(~exist('raw_pinknoise.wav', 'file'))
                    audiowrite('raw_pinknoise.wav',p,48000);
                end
                        
                cd(root);
                hObject.Enable = 'off';
                pause(d);
                sound(p,48000);
                pause(t);
                hObject.Enable = 'on';
            end
        end
    end
