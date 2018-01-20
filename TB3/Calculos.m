


fp = 9*1e9;
c = 3*1e8;
lambda = c/fp;
vel = 0.3;
PRF = 288;
theta = 6;

Ti = theta/(6*vel);
ni = Ti*PRF;

fc = (sqrt(log(2))/Ti);
fd = 2*Vr*lambda;


        RC_1 = (PRF/(pi*fc))^2;
        I_MTI_1 = RC*(sin((pi*fd)/PRF)^2);
        I_MTI_m_1 = (1/2)*(PRF/(pi*fc))^2;

        RC_2 = (1/3)*(PRF/(pi*fc))^2;
        I_MTI_2 = RC*(sin((pi*fd)/PRF)^4);
        I_MTI_m_2 = (1/28)*(PRF/(pi*fc))^2;
     
        RC_3 = (PRF/(pi*fc))^2;
        I_MTI_3 = RC*sin((pi*fd)/PRF)^2;
        I_MTI_m_3 = (1/2)*(PRF/(pi*fc))^2;
        
% Radar Pulsado

