%%  ================================================================
% demo_cs.m 

%  This program is used to demonstrate how to use CS_NLTV (compress sensing with NLTV) code
%  This demo sets up a subsampled Fourier matrix, A=RF, where R is a diagonal matrix with  entries randomly chosen 
%  to be 1 or 0, and F is the Fourier transform matrix. The compressed sensing data is then computed using the
%  folrmula Fp = Fmask.*fft2(image).  Gaussian noise could be  added to the CS data.
%  Finally, the CS_NLTV method is used to reconstruct the image from the sub-sampled  Fourier data w/o noise.

%  Xiaoqun ZHANG (xqzhang@math.ucla.edu)
%  Last modified 02/28/2009

clear all;
close all;
if 0
name='barbara256.png'; %Example 1
I=double(imread(name));
[M,N]=size(I);
Fmask = rand(M,N);
sparsity = 0.3; 
Fmask = Fmask<sparsity;

else
   load barbar_test;
   I=double(I);
   [M,N]=size(I);
end
%% optional: including low frequence [-k:k]*[-k:k],k=0.01*N to improve the visual quality
includeLow=0;
if (includeLow)
k1=round(0.02*M);
k2=round(0.02*N);
Fmask(1:k1,1:k2)=1;
Fmask(M-k1+1:M,1:k2)=1;
Fmask(1:k1,N-k2+1:N)=1;
Fmask(M-k1+1:M,N-k2+1:N)=1;
end

real_sparsity= nnz(Fmask)/(M*N);

%% simulate normalized Fourier space data
[M,N]=size(I);
scale=sqrt(M*N);
F=fft2(I)/scale;
Fp=F.*Fmask;

%  w/o noise
noise=0;
if (noise==0)
    sigma=0;
else 
    sigma=1;
 Fp=  Fp+randn(size(Fp))*sigma;
end

%% Reconstruction by setting unknown zeros
time_I0=cputime;
I0=real(ifft2(Fp))*scale;
time_I0=cputime-time_I0;

%% Reconstruction by TV regularization: min TV(u) s.t. Au=Fp;
%[uTV,energy_tv] = mrics(Fmask,Fp, lambda, mu,gamma, nInner, nOuter);
opts.mu=1;
opts.I=I; %% ground truth or a reference image to measure image quality, optional
opts.nOuter=100;
time_TV=cputime;
[uTV,energy_tv,relmse_tv,psnr_tv]=CS_TV(Fp,Fmask,opts);
uTV=real(uTV);
time_TV=cputime-time_TV
%% initialize parameters set for nonlocal cs reconstruction
%Input 
opts.h0=20; %
opts.mu=10; % regularization scale parameter used in NLTV 
opts.I=I; %% ground truth or a reference image to measure image quality, optional
opts.nOuter=500;
opts.nDenoising=20;
opts.nWin=2;
opts.nBloc=10;
opts.nNeigh=10;
opts.nWeightupdate=20;
opts.verbose=1;
% By bregmanized operator splitting
output_bos = struct('Img',zeros(M,N),'time', 0,'energy',[],'relmse',[],'psnr_n',[]);
time_bos=cputime;
[uNLTV,energy,relmse,psnr_n]=CS_NLTV(Fp,Fmask,opts);

time_bos =cputime-time_bos
output_bos=writeresult(output_bos,uNLTV,time_bos,energy,relmse,psnr_n);
%%
%% initialize parameters set for nonlocal cs reconstruction
%Input 
opts.h0=20; %
opts.mu=5; % regularization scale parameter used in NLTV 
opts.I=I; %% ground truth or a reference image to measure image quality, optional
opts.nOuter=100;
opts.nDenoising=20;
opts.nWin=2;
opts.nBloc=10;
opts.nNeigh=10;
opts.nWeightupdate=20;
opts.verbose=1;
% By bregmanized operator splitting
output_NLH1 = struct('Img',zeros(M,N),'time', 0,'energy',[],'relmse',[],'psnr_n',[]);
time_NLH1=cputime;
[uNLH1,energy,relmse,psnr_n]=CS_NLH1(Fp,Fmask,opts);
time_NLH1 =cputime-time_NLH1

output_NLH1=writeresult(output_NLH1,uNLH1,time_NLH1,energy,relmse,psnr_n);


%By preconditioned bregman operator splitting
% output_pbos =struct('Img',zeros(M,N),'time', 0,'energy',[],'relmse',[],'psnr_n',[]);
% opts.type=2;
% time_pbos=cputime;
% [uNLTV_pbos,energy_nltv,relmse,psnr_n]=CS_NLTV(Fp,Fmask,opts);
% time_pbos =cputime-time_pbos
%% By wavelet GPSR:
opts.tau= 0.05;
opts.first_tau_factor= 200;
[u_GPSR,mse_BB_mono_cont]=IST_CS(Fp,Fmask,opts);

%% Plot results
%images
figure
subplot(231),imshow(I,[ ]),title('Original');
subplot(232),imshow(I0,[ ]),title(['Initial guess by setting unknown 0, PSNR=',num2str(PSNR(I,I0))]);
subplot(233),imshow(uTV,[ ]),title(['TV  reconstructed, PSNR=',num2str(PSNR(I,uTV))]);
subplot(234),imshow(uNLTV,[]),title(['NLTV reconstructed, PSNR=',num2str(PSNR(I,uNLTV))]);
subplot(235),imshow(uNLH1,[ ]),title(['NLH1, PSNR=',num2str(PSNR(I,uNLH1))]);
subplot(236),imshow(u_GPSR,[ ]),title(['Wavelet GPSR reconstructed, PSNR=',num2str(PSNR(I,u_GPSR))]);
%%
name='barba';
dir='\results';

image_name=[name,'_original.eps'];  
image2eps(I,image_name,dir);

image_name=[name,'_init.eps'];
image2eps(I0,image_name,dir);


image_name=[name,'_tv.eps'];
image2eps(uTV,image_name,dir);

image_name=[name,'_nltv.eps'];
image2eps(uNLTV,image_name,dir);

image_name=[name,'_nlh1.eps'];
image2eps(uNLH1,image_name,dir);

image_name=[name,'_wave_gpsr.eps'];
image2eps(u_GPSR,image_name,dir);


% plot((psnr_n),'DisplayName','NLTV',...
%     'MarkerSize',4,...
%     'Marker','square',...
%     'LineStyle','--',...
%     'Color',[0 0 1]);
% legend('show');

% % energy
% figure
% set(gca,'FontName','Times','FontSize',16,'LineWidth',2)
% plot(log10(energy_tv),'DisplayName','TV','MarkerSize',4,...
%     'Marker','diamond',...
%     'LineStyle',':',...
%     'Color',[1 0 0]);
% 
% hold on
% plot(log10(energy),'DisplayName','NLTV',...
%     'MarkerSize',4,...
%     'Marker','square',...
%     'LineStyle','--',...
%     'Color',[0 0 1]);
% legend('show');
% 
% xlabel('Iterations')
% ylabel('Residual')

