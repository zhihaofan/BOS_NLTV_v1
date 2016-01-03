function y=psyHAT(x,deg)
%auxillary function for computing Meyer 
%wavelet in the Fourier domain

aux1=WindowMeyer((3.*abs(x)-1),deg);
aux2=WindowMeyer((3.*abs(x)./2-1),deg);

sin_part=(exp(-i*pi.*x)).*sin(pi.*aux1./2);
cos_part=(exp(-i*pi.*x)).*cos(pi.*aux2./2);

y1=sin_part.*(abs(x)>1/3 & abs(x)<=2/3);
y2=cos_part.*(abs(x)>2/3 & abs(x)<=4/3);

y=y1+y2;


%   Written by Marc Raimondo, the University of Sydney, 2003. 
%   Copyright the University of Sydney, 2003. 
%   Comments? e-mail marcr@maths.usyd.edu.au
 
    