function u1=denoising_SBNLTV(u0,mu,lambda,lambda_SKR,inner,wopts,wopts_SKR,HR,lambda_DL)
 [Ny,Nx]=size(u0);
 %mu=1./mu; % to be consistent with the code: mu is on the fidelity term in the denosing code
display_messages = 0;

 VecGeneralParameters = [ display_messages; Ny; Nx; wopts.m; wopts.w; wopts.NbNeigh; lambda; lambda_SKR; mu; inner;lambda_DL];

d = zeros(Nx,Ny,wopts.NbNeigh);
b = zeros(Nx,Ny,wopts.NbNeigh);

ds = zeros(Nx,Ny,wopts.NbNeigh);
bs = zeros(Nx,Ny,wopts.NbNeigh);

u1 = SBNLTV_mex(single(u0),single(d),single(b),single(ds), single(bs),single(u0),...
    single(wopts.W),int32(wopts.Y),single(wopts_SKR.W),int32(wopts_SKR.Y),single(VecGeneralParameters),single(HR));
