function [MatrizIntegrada] = integrador(pulsado_fmcw, rampa, MatrizInput,Ni)

% ojo con el conjugado de la matriz
MatrizModulo = abs(MatrizInput);
velocidad = 0.3; % 30 cm/s

if pulsado_fmcw ==1 && rampa==0
  
    PRF=288;
    T=1/PRF;
    avance_maximo = velocidad*T; %en segundos
    resolucion = 0.15; % en metros y obtenido en el primer apartado del TB3
%     instantes_de_tiempo = floor(resolucion/avance_maximo); %N? de instantes de tiempo que tarda el blanco en desplazarse una celda de resoluciŪn

    for i=1:size(MatrizModulo,2)
         MatrizRadar_fR_fT(:,i) = filter((1/Ni)*ones(1,Ni),1,MatrizModulo(:,i),[],2);
         MatrizIntegrada = MatrizRadar_fR_fT(:,(Ni:end));
    end
    
elseif pulsado_fmcw ==2
    fs=100000;
 if rampa == 1 
    t_rampa=0.001;
    resolucion = 0.075;
    R = ((3*10^8)*fs) / (2*(1 / t_rampa)*(2*10^9));
elseif rampa == 2
    t_rampa=0.3;
    resolucion = 0.075;   
    R = ((3*10^8)*fs) / (2*(1 / t_rampa)*(2*10^9));
 end
 
    fm=1/t_rampa;
    avance_maximo = velocidad*(1/fm); %en segundos
%     Ni = round(resolucion/avance_maximo); %N? de instantes de tiempo que tarda el blanco en desplazarse una celda de resoluciŪn

for i=1:size(MatrizModulo,2)
    MatrizRadar_fR_fT(:,i) = filter((1/Ni)*ones(1,Ni),1,MatrizModulo(:,i),[],2);
    MatrizIntegrada = MatrizRadar_fR_fT(:,(Ni:end));
end
    
end






end