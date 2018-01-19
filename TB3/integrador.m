function [MatrizIntegrada] = integrador(pulsado_fmcw, rampa, MatrizInput,Ni)

MatrizModulo = abs(MatrizInput);
velocidad = 0.3; % 30 cm/s

if pulsado_fmcw ==1 && rampa==0
  
%     PRF=288;
%     T=1/PRF;
%     avance_maximo = velocidad*T; %en segundos
%     resolucion = 0.15; % en metros y obtenido en el primer apartado del TB3
%     Ni = floor(resolucion/avance_maximo); %N? de instantes de tiempo que tarda el blanco en desplazarse una celda de resoluciŪn

    for i=1:size(MatrizModulo,1)
         MatrizRadar_fR_fT(i,:) = filter((1/Ni)*ones(1,Ni),1,MatrizModulo(i,:),[],2);
%          MatrizIntegrada = MatrizRadar_fR_fT((Ni:end),:);
    end
    MatrizIntegrada=MatrizRadar_fR_fT;
    
elseif pulsado_fmcw ==2
    fs=100000;
 if rampa == 1 
    t_rampa=0.001;
    resolucion = 0.075;
    R = ((3*10^8)*fb*t_rampa) / (2*(1*10^9));
elseif rampa == 2
    fb=16500;
    t_rampa=0.3;
    resolucion = 0.075;   
    R = ((3*10^8)*fb*t_rampa) / (2*(1*10^9));
 end
 
 
    fm=1/t_rampa;
    avance_maximo = velocidad*(1/fm); %en segundos
    %Ni = round(resolucion/avance_maximo); %N? de instantes de tiempo que tarda el blanco en desplazarse una celda de resoluciŪn

    for i=1:size(MatrizModulo,1)
        MatrizRadar_fR_fT(i,:) = filter((1/Ni)*ones(1,Ni),1,MatrizModulo(i,:),[],2);
    %     MatrizIntegrada = MatrizRadar_fR_fT((Ni:end),:);
    end
    MatrizIntegrada = MatrizRadar_fR_fT;
end


end