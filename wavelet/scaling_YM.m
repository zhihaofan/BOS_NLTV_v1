function y=scaling_YM(j,j_max,deg)
%generate phyHAT(j,0)--the fft of the scaling function--in the periodic setting.
%% deg=deg of the Meyer wavelet (1,2,3).
omega_pos=(0:1/(2^j):10/(2*pi));
n_pos=length(omega_pos);

nn=2^j_max;
%omega_neg=(-10/(2*pi):1/(2^j):-1/2^j);
%n_omega=2*length(omega_pos)-1;
%n=2^j_max-n_omega;
%phy_fft_LEFT=phyHAT(omega_pos,deg);


%rotate and take zero out
%aux=rot90(phy_fft_LEFT)';
%aux=aux(1:(n_pos-1));


%phy_fft_RIGHT=aux;

%phy_fft=[phy_fft_LEFT zeros(1,n) phy_fft_RIGHT];
%nn=length(phy_fft);

%y=phy_fft.*2^(-j/2).*nn;




aux1=phyHAT(omega_pos,deg);
%rotate and take zero out

psyHAT_LEFT=zeros(1,nn);
psyHAT_LEFT(1:n_pos)=aux1;
aux2=psyHAT_LEFT;
aux2(1)=[];
aux2=[aux2 0];
psyHAT_RIGHT=rot90(aux2)';



%aux=rot90(psy_fft_LEFT)';
%aux=aux(1:(n_pos-1));


%psy_fft_RIGHT=aux;

%psy_fft=[psy_fft_LEFT zeros(1,n) psy_fft_RIGHT];



%nn=length(psy_fft);

%y=psy_fft.*2^(-j/2).*nn;

y=(psyHAT_RIGHT+psyHAT_LEFT).*2^(-j/2).*nn;




%   Written by Marc Raimondo, the University of Sydney, 2003. 
%   Copyright the University of Sydney, 2003. 
%   Comments? e-mail marcr@maths.usyd.edu.au
 
    