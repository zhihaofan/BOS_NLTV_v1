function [u0,energy,relmse,psnr_n]=Decon_NLTV(f,H,opts)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% f:    [M,N] Blur Image ---------------------- normalized Fourier measurement data
%%% H:  Blur kernel
%%% opts: parameters set.
%%% 

if (nargin<3)
    opts=[];
end

%% Initialization 
% Regularization parameters
if ~isfield(opts,'mu')     opts.mu=20; end %% regularization term scale
if ~isfield(opts,'delta')  opts.delta=1; end %% delta<||A^*A||, since A here is a subsampled Fourier matrix, could be fixed to be 1.
if ~isfield(opts,'nOuter') opts.nOuter=20; end %% Outer Bregman iteration steps.
if ~isfield(opts,'nDenoising') opts.nDenoising=10; end%% 3st level: denoising/regularization level, in general could be fixed to be 10
if ~isfield(opts,'type')  opts.type=1; end %% 1: by bos,2:PBOS. 3:by Linearized Bregman If the without noise (or low), choose 1
if ~isfield(opts,'bTol') opts.bTol=10^-5; end %%stopping criterion on residual std2(Fmask.*fft2(u)/N-Fp), if the noise standard variation is known, can set btol to be sigma
if ~isfield(opts,'xTol') opts.xTol=10^-5; end %%stopping criterion, if the noise standard variation is known, can set btol to be sigma
if ~isfield(opts,'verbose') opts.verbose=0; end %% display message

% Weight parameters 
if ~isfield(opts,'h0')  opts.h0=20; end %% weight filter parater, depends on noise and image standard variation. for example: for barbara [0, 255], h0=20; To be adapted for normalized image
if ~isfield(opts,'nWin') opts.nWin=2;  end    %% patch size [2*nwin+1, 2*nwin+1]
if ~isfield(opts,'nBloc') opts.nBloc=10; end   %% search window size [2*bloc+1, 2*bloc+1]
if ~isfield(opts,'nNeigh') opts.nNeigh=10; end   %% number of best neighbors (real neighbors size: 2*nNeigh+4)
if ~isfield(opts,'nWeightupdate') opts.nWeightupdate=0;  end % weight update 
if ~isfield(opts,'denoising_type') opts.denoising_type=1; end %% NLTV denoising algorithm:1: Split bregman, 2: Projection in dual

[M,N]=size(f);
n=0;
otf=psf2otf(H,[M,N]);
A=@(x)real(ifft2(fft2(x).*otf));
AT=@(x)real(ifft2(fft2(x).*conj(otf)));
if ~isfield(opts,'init') opts.init=real(AT(f)); end 

u00=opts.init;
%% %%%%%%%%%%%%%%% Main Loop%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
energy=[];
relmse=[];
psnr_n=[];

u0=u00;
v1=u0;
v0=u0;
tau=1./(opts.delta*opts.mu);

if opts.type==2
    diag=abs(otf).^2+opts.epsilon;
end
 if (~isfield(opts,'wopts'))
         wopts=update_weight(opts.Init,opts.h0,opts.nWin,opts.nBloc);

 else       
         wopts=opts.wopts;
         opts = rmfield(opts, 'wopts');
 end


%% Main outer loop: 1st level
condition=1;
while (condition)
    u2=u0;
    u0_F=A(u0);
   resU=AT(f-u0_F);
    switch opts.type 
        case 1 %% by bregmanized operator splitting
        v0=v0+resU;
        v1= u0+opts.delta*(v0+resU-u00);
        case 2  % PBOS
           % if (n<10) mu_k=max(mu_k0/(n+1),1); else mu_k=1./opts.delta;end % trick to improve deblurring result with PBOS: start with a larger delta (noisy but well deblurred)
        v0=v0+resU;
        v1= u0+opts.delta*real(ifft2(fft2(v0-AT(A(u0)))./diag));       
        
        case 3   %% by linearized bregman
      v1=v1+opts.delta*resU;       
        case 4
       v1=u0+ opts.delta* resU;
       otherwise
      disp('Unknown method.')
    end
           
        if (opts.nWeightupdate)
            if(mod(n,opts.nWeightupdate)==0)  
         wopts=update_weight(real(v1),opts.h0,opts.nWin,opts.nBloc);   
            end
        end
     if (opts.denoising_type==1)
    %   u1=denoising_SBNLTV(v1,tau,wopts,opts.nDenoising); 
           u1=denoising_SBNLTV(v1,tau,tau./4,opts.nDenoising,wopts);

     else
     u1=denoising_NLTV_proj(v1,tau,opts.nOuter,wopts);
     end     
     u0=u1;
 n=n+1;
 
   res=f-A(u0); 
   energy=[energy;norm(res,'fro')^2]; 
   relmse=[relmse;norm(u2-u0,'fro')/norm(u2,'fro')]; 
 
 if isfield(opts,'I') psnr_n=[psnr_n;PSNR(opts.I,u0)];end
 if (opts.verbose) 
     fprintf('\n n=%d,residual std2=%f, relative diff =%f',n-1,energy(n),relmse(n));
    if isfield(opts,'I')  fprintf(',PSNR(u0) =%f',psnr_n(n));end
 end
    noise=std2(res);
 condition=(n<opts.nOuter&& noise>opts.bTol&&relmse(n)>opts.xTol);
end







 
    