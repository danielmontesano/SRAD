function [MatrizIntegrada] = integrador(pulsado_fmcw, MatrizInput,Ni)

MatrizModulo = abs(MatrizInput);

if pulsado_fmcw ==1 
 

    for i=1:size(MatrizModulo,1)
         MatrizRadar_fR_fT(i,:) = filter((1/Ni)*ones(1,Ni),1,MatrizModulo(i,:),[],2);
%          MatrizIntegrada = MatrizRadar_fR_fT((Ni:end),:);
    end
    MatrizIntegrada=MatrizRadar_fR_fT;
    
elseif pulsado_fmcw ==2

    for i=1:size(MatrizModulo,1)
        MatrizRadar_fR_fT(i,:) = filter((1/Ni)*ones(1,Ni),1,MatrizModulo(i,:),[],2);
    %     MatrizIntegrada = MatrizRadar_fR_fT((Ni:end),:);
    end
    MatrizIntegrada = MatrizRadar_fR_fT;
end


end