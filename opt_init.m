function [opts] = opt_init()
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
opts = [];
if ~isfield(opts,'mu')     opts.mu=20; end %% regularization term scale
if ~isfield(opts,'delta')  opts.delta=1; end %% delta<||A^*A||, since A here is a subsampled Fourier matrix, could be fixed to be 1.
if ~isfield(opts,'nOuter') opts.nOuter=5; end %% Outer Bregman iteration steps.
if ~isfield(opts,'nInner') opts.nInner=10; end %% Outer Bregman iteration steps.
if ~isfield(opts,'nDenoising') opts.nDenoising=8; end%% 3st level: denoising/regularization level, in general could be fixed to be 10
if ~isfield(opts,'type')  opts.type=1; end %% 1: by bos,2:PBOS. 3:by Linearized Bregman If the without noise (or low), choose 1
if ~isfield(opts,'bTol') opts.bTol=10^-5; end %%stopping criterion on residual std2(Fmask.*fft2(u)/N-Fp), if the noise standard variation is known, can set btol to be sigma
if ~isfield(opts,'xTol') opts.xTol=10^-5; end %%stopping criterion, if the noise standard variation is known, can set btol to be sigma
if ~isfield(opts,'verbose') opts.verbose=0; end %% display message

% Weight parameters 
if ~isfield(opts,'h0')  opts.h0=20; end %% weight filter parater, depends on noise and image standard variation. for example: for barbara [0, 255], h0=20; To be adapted for normalized image
if ~isfield(opts,'nWin') opts.nWin=2;  end    %% patch size [2*nwin+1, 2*nwin+1]
if ~isfield(opts,'nBloc') opts.nBloc=10; end   %% search window size [2*bloc+1, 2*bloc+1]
if ~isfield(opts,'nNeigh') opts.nNeigh=10; end   %% number of best neighbors (real neighbors size: 2*nNeigh+4)
if ~isfield(opts,'nWeightupdate') opts.nWeightupdate=20;  end % weight update 
if ~isfield(opts,'denoising_type') opts.denoising_type=1; end %% NLTV denoising algorithm:1: Split bregman, 2: Projection in dual
%if ~isfield(opts,'Init') opts.Init=u; end;

end

