function y=wavelet_YM(j,j_max,deg)
%generate psyHAT(j,0)--the fft of the (periodic) Meyer wavelet--at resolution level j.
%%--dyadic sample size---
%%j=resolution level
%% j_max=maximum resolution level
%% sample size =2^j_max
omega_pos=(0:1/(2^j):10/(2*pi));
n_pos=length(omega_pos);

nn=2^j_max;
omega_neg=(-10/(2*pi):1/(2^j):-1/2^j);





n_omega=2*length(omega_pos)-1;
n=2^j_max-n_omega;
aux1=psyHAT(omega_pos,deg);
%rotate and take zero out

psyHAT_LEFT=zeros(1,nn);
psyHAT_LEFT(1:n_pos)=aux1;
aux2=psyHAT_LEFT;
aux2(1)=[];
aux2=[aux2 0];
psyHAT_RIGHT=rot90(aux2)';



y=(psyHAT_RIGHT+psyHAT_LEFT).*2^(-j/2).*nn;


%   Written by Marc Raimondo, the University of Sydney, 2003. 
%   Copyright the University of Sydney, 2003. 
%   Comments? e-mail marcr@maths.usyd.edu.au
 
    