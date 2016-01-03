function y=phyHAT(x,deg)
%auxillary function for computing Meyer scaling function
% in the Fourier domain

aux1=WindowMeyer((3.*abs(x)-1),deg);


cos_part=cos(pi.*aux1./2);

y1=cos_part.*(abs(x)>1/3 & abs(x)<=2/3);
y2=ones(1,length(x)).*(abs(x)<=1/3);
y=y1+y2;


%   Written by Marc Raimondo, the University of Sydney, 2003. 
%   Copyright the University of Sydney, 2003. 
%   Comments? e-mail marcr@maths.usyd.edu.au
 
    