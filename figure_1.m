clear all
close all

% set up cameram man example
I = double(imread('cameraman.tif'));
H = fspecial('average',9);
%H=fspecial('Gaussian',21,2);

[M,N]=size(I);

%% Add blur and noise
B = imfilter(I,H,'circular');
sigma=3;
Bn = B+randn(M,N)*sigma;

%% Pre-compute the weight by tikronov optimal reconstruction
[Im0, sigma1, lambda,err] = tikronov_optimal_lambda(Bn, H, sigma);
% TV reconstruction
opts.bTol=0.99*sigma; % stop when ||Au-g||\leq btol*sigma for noise case
opts.Init=Im0;
opts.I=I;
opts.nWeightUpdate=0;


%%
% time = cputime;
% opts.type=1;
% opts.mu=5; %
%  [uTV_bos,energy,relmse,psnr_n]=Decon_TV(Bn,H,opts);
%  time=cputime-time;

%uTV=deconvrof(Bn,H,1,100,0.01);
 
%%
opts.h0=2*sigma1;
opts.nDenoising=20;
opts.type=1;
opts.mu=10; %
time_nltv_bos=cputime;
 [uNLTV_bos,energy,relmse,psnr_n_nltv_bos]=Decon_NLTV(Bn,H,opts);
 time_nltv_bos=cputime-time_nltv_bos
%%
% opts.type=2;
% opts.mu=20;
% opts.epsilon=0.1;
% time_nltv_pbos=cputime;
%  [uNLTV_pbos,energy,relmse,psnr_n_nltv_pbos]=Decon_NLTV(Bn,H,opts);
%  time_nltv_pbos=cputime-time_nltv_pbos
% %% 
%  time = cputime;
% opts.type=1;
% opts.mu=5;
%  [uNLH1_bos,energy,relmse,psnr_n]=Decon_NLH1(Bn,H,opts);
%  time=cputime-time;
% 
%  %%
% opts.type=2;
% opts.mu=10;
% opts.epsilon=0.1;
% opts.nWeightUpdate=0;
% time = cputime;
%  [uNLH1_pbos,energy,relmse,psnr_n]=Decon_NLH1(Bn,H,opts);
%  time=cputime-time;
%  
% %% Other comparison 
%  u_GPSR=GPSR_decon(Bn,H,[]);
% %% gradient descent for nltv 
% time_gd=cputime;
%  w=nlmeans_weight_sym(Im0,sigma1,2,10);
%  [uNLTV_gd,k,energy,NLTVtime] = nonlocalTV_decon(Bn,H,w,15,500,Im0);
%  time_gd=cputime-time_gd
% %%
%  figure 
% subplot(331),imshow(I,[0 255 ]),title('Original');
% subplot(332),imshow(Bn,[0 255 ]),title('Blurry');
% %subplot(333),imshow(Im0,[0 255 ]),title(['Initial guess by setting unknown 0, PSNR=',num2str(PSNR(I,Im0))]);
% subplot(333),imshow(uNLTV_gd,[0 255 ]),title(['NLTV with Gradient descent, PSNR=',num2str(PSNR(I,uNLTV_gd))]);
% subplot(334),imshow(uTV_bos,[0 255 ]),title(['TV, PSNR=',num2str(PSNR(I,uTV_bos))]);
% 
% subplot(335),imshow(uNLH1_bos,[0 255  ]),title(['NLH1 BOS, PSNR=',num2str(PSNR(I,uNLH1_bos))]);
% subplot(336),imshow(uNLH1_pbos,[0 255 ]),title(['NLH1 PBOS, PSNR=',num2str(PSNR(I,uNLH1_pbos))]);
% subplot(337),imshow(uNLTV_bos,[0 255 ]),title(['NLTV BOS, PSNR=',num2str(PSNR(I,uNLTV_bos))]);
% subplot(338),imshow(uNLTV_pbos,[0 255 ]),title(['NLTV PBOS, PSNR=',num2str(PSNR(I,uNLTV_pbos))]);
% subplot(339),imshow(u_GPSR,[0 255 ]),title(['GPSR , PSNR=',num2str(PSNR(I,u_GPSR))]);
% 
% %%
% if 0
% name='cameraman_deblur';
% dir='\results';
% gmin=0;
% gmax=255;
% image_name=[name,'_original.eps'];  
% image2eps(I,image_name,dir,gmin,gmax);
% 
% 
% image_name=[name,'_blur.eps'];  
% image2eps(Bn,image_name,dir,gmin,gmax);
% 
% image_name=[name,'_init.eps'];
% image2eps(Im0,image_name,dir,gmin,gmax);
% 
% 
% image_name=[name,'_tv.eps'];
% image2eps(uTV_bos,image_name,dir,gmin,gmax);
% 
% image_name=[name,'_nltv_bos.eps'];
% image2eps(uNLTV_bos,image_name,dir,gmin,gmax);
% 
% image_name=[name,'_nltv_pbos.eps'];
% image2eps(uNLTV_pbos,image_name,dir,gmin,gmax);
% 
% image_name=[name,'_nltv_bos.eps'];
% image2eps(uNLTV_bos,image_name,dir,gmin,gmax);
% 
% image_name=[name,'_nlh1_pbos.eps'];
% image2eps(uNLH1_pbos,image_name,dir,gmin,gmax);
% 
% 
% image_name=[name,'_nlh1_bos.eps'];
% image2eps(uNLH1_bos,image_name,dir,gmin,gmax);
% 
% image_name=[name,'_wave_gpsr.eps'];
% image2eps(u_GPSR,image_name,dir,gmin,gmax);
% %
% image_name=[name,'_nltv_gd.eps'];
% image2eps(uNLTV_gd,image_name,dir,gmin,gmax);
