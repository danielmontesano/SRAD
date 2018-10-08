

clc
fp = 9*1e9;
c = 3*1e8;
lambda = c/fp;
vel = 0.3;
PRF = 288;
theta = 6;

Ti = 0.5;

fc = (sqrt(log(2))/Ti);
fd = 2*vel*lambda;


        RC_1 = (PRF/(pi*fc))^2;
        I_MTI_1 = RC_1*(sin((pi*fd)/PRF)^2);
        I_MTI_m_1 = (1/2)*(PRF/(pi*fc))^2;

        RC_2 = (1/3)*(PRF/(pi*fc))^4;
        I_MTI_2 = RC_2*(sin((pi*fd)/PRF)^4);
        I_MTI_m_2 = (1/8)*(PRF/(pi*fc))^4;
     
        RC_3 = (1/15)*(PRF/(pi*fc))^6;
        I_MTI_3 = RC_3*sin((pi*fd)/PRF)^6;
        I_MTI_m_3 = (1/48)*(PRF/(pi*fc))^6;
        
        vec = [RC_1 I_MTI_1 I_MTI_m_1;
               RC_2 I_MTI_2 I_MTI_m_2;
               RC_3 I_MTI_3 I_MTI_m_3];
           10*log10(vec)
                
% Radar Pulsado

