function [MatrizCancelada] = cancelador(orden, MatrizRadar)
%CANCELADOR Simple, Doble o Triple
%


if orden == 1
    
    coefs = [0.5 -0.5];
    MatrizCancelada = filter(coefs,1,MatrizRadar,[],2);
    MatrizCancelada = MatrizCancelada(:,1:end); 
    
elseif orden == 2
    
    coefs = [0.25 -0.5 0.25];
    MatrizCancelada = filter(coefs,1,MatrizRadar,[],2);
    MatrizCancelada = MatrizCancelada(:,2:end); 
    
elseif orden == 3
    
    coefs = [0.125 -0.375 0.375 -0.125];
    MatrizCancelada = filter(coefs,1,MatrizRadar,[],2);
    MatrizCancelada = MatrizCancelada(:,3:end); 
    
else
    
    MatrizCancelada = MatrizRadar;
end
    
end

