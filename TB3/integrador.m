function [MatrizIntegrada] = integrador(pulsado_fmcw,  MatrizInput)

% ojo con el conjugado de la matriz
MatrizModulo = abs(MatrizInput);
velocidad = 0.3; % 30 cm/s

if pulsado_fmcw ==1 && rampa==0
  
    PRF=288;
    T=1/PRF;
    avance_maximo = velocidad*T; %en segundos
    resolucion = 0.15; % en metros y obtenido en el primer apartado del TB3
%     instantes_de_tiempo = floor(resolucion/avance_maximo); %N? de instantes de tiempo que tarda el blanco en desplazarse una celda de resoluciŪn
    instantes_de_tiempo = 20;
     
    for i=1:size(MatrizModulo,2)
         MatrizRadar_fR_fT(:,i) = filter((1/instantes_de_tiempo)*ones(1,instantes_de_tiempo),1,MatrizModulo(:,i),[],2);
    %     [fila_aux columna_aux] = size(MatrizRadar_fR_fT);
         MatrizIntegrada = MatrizRadar_fR_fT(:,(instantes_de_tiempo:end));
    end

elseif pulsado_fmcw ==2
    

t_rampa=0.003;
fm=1/t_rampa;
avance_maximo = velocidad*(1/fm); %en segundos


 if rampa == 1 
resolucion = 0.15;
 R = ((3*10^8)*fs) / (2*(1 / t_rampa)*(1*10^9));
elseif rampa == 2
resolucion = 0.075;   
 R = ((3*10^8)*fs) / (2*(1 / t_rampa)*(2*10^9));
 end

        % en metros y obtenido en el primer apartado del TB3 para 1GHz de recorrido
instantes_de_tiempo = floor(resolucion/avance_maximo); %N? de instantes de tiempo que tarda el blanco en desplazarse una celda de resoluciŪn

MatrizRadar_fR_fT = filter((1/instantes_de_tiempo)*ones(1,instantes_de_tiempo),1,MatrizModulo,[],2);
[fila_aux columna_aux] = size(MatrizRadar_fR_fT);
MatrizIntegrada = MatrizRadar_fR_fT(:,instantes_de_tiempo:columna_aux);

end






end