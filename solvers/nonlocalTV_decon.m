function [u,k,energy, NLTVtime] = nonlocalTV_decon(f,h, w,lambda,iters,u0)

% Copyright(C)Xiaoqun Zhang, 2008
tic

dt = 0.5;
eps = 1e-5;
[M,N]=size(f);
MN = M*N;
%Inital u0=simple wiener image

v=imfilter(u0,h,'circular')-f;

%grad of H and H
gradH0=reshape(imfilter(v,h,'circular'),MN,1);
Hu=norm(v,'fro')^2/MN;

u0=reshape(u0,MN,1);    
u=u0;
w1=sum(w,2);


uu=w*u;
 gradu = abs(1./sqrt(w*(u.^2)-2*uu.*u + w1.*(u.^2)+eps));
 gradJ = gradu.*(uu)+w*(gradu.*u);
%gradJ = gradu.*(uu)+w*(gradu.*u)-gradu.*u.*w1-u.*(w*gradu);

Ju=sum(1./gradu)/MN;

grad0 = gradJ-lambda*gradH0;

k = 1;
energy=[];
E1= sqrt((lambda*Hu + Ju));
energy=[energy;E1];
% snrk=[];
% snn=SNR(I,u);
% snrk=[snrk;snn];

E0=1;

while (k<iters) & (abs(E0-E1)>eps) & (dt>eps)
        E1 = energy(k);
    uu=w*gradu;
     u = (u0+grad0*dt)./(1+dt*gradu.*w1+dt*uu);
   
      v = reshape(u, M,N);
    v=imfilter(v,h,'circular')-f;
    Hu=norm(v,'fro')^2/MN;
    
  uu=w*u;
  oldgradu=gradu;

  
  Ju=sum(sum(abs(1./gradu)))/MN;
 gradu = abs(1./sqrt(w*(u.^2)-2*uu.*u + w1.*(u.^2)+eps));
   
    E0 =  sqrt(lambda*Hu + Ju);
   
    if E0 < energy(k) 
           k = k+1;
        u0=u;
         gradH0=reshape(imfilter(v,h,'circular'),MN,1);
%         gradJ = gradu.*(uu)+w*(gradu.*u)-gradu.*u.*w1-u.*(w*gradu);
         gradJ = gradu.*(uu)+w*(gradu.*u);
         grad0 = gradJ-lambda*gradH0;
         energy=[energy; E0];
%          snn=SNR(I,u);
%          snrk=[snrk; snn];
%                 
    else
      gradu=oldgradu;   
           dt = .8*dt;
    end
    
end
  
NLTVtime=toc;
u = reshape(u,M,N);
