function [MatrizIntegrada] = integrador(rampa, MatrizRadar)

% ojo con el conjugado de la matriz
MatrizModulo = abs(MatrizRadar);

velocidad = 0.3; % 30 cm/s
avance_maximo = velocidad*(1/fm); %en segundos
 if rampa == 1 
resolucion = 0.15;
 R = ((3*10^8)*f) / (2*(1 / t_rampa)*(1*10^9));
elseif rampa == 2
resolucion = 0.075;   
 R = ((3*10^8)*f) / (2*(1 / t_rampa)*(2*10^9));
 end

        % en metros y obtenido en el primer apartado del TB3 para 1GHz de recorrido
instantes_de_tiempo = floor(resolucion/avance_maximo); %N? de instantes de tiempo que tarda el blanco en desplazarse una celda de resoluci€n

MatrizRadar_fR_fT = filter((1/instantes_de_tiempo)*ones(1,instantes_de_tiempo),1,MatrizModulo,[],2);
[fila_aux columna_aux] = size(MatrizRadar_fR_fT);
matriz_radar_integrada = MatrizRadar_fR_fT(:,instantes_de_tiempo:columna_aux);








end