function [u1,u2]=GPSR_decon(Bn,H,opts)
% This demo shows the reconstruction of a sparse image
% of randomly placed plus an minus ones
% 

[m n] = size(Bn);

if ~isfield(opts,'Jwin') opts.Jwin=floor(log2(m))-1;  end   
if ~isfield(opts,'wav') opts.wav= daubcqf(4);  end  

otf=psf2otf(H,size(Bn));
% definde the function handles that compute 
% the blur and the conjugate blur.
R = @(x) real(ifft2(otf.*fft2(x)));
RT = @(x) real(ifft2(conj(otf).*fft2(x)));

% define the function handles that compute 
% the products by W (inverse DWT) and W' (DWT)
W = @(x) midwt(x,opts.wav,opts.Jwin);
WT = @(x) mdwt(x,opts.wav,opts.Jwin);

%Finally define the function handles that compute 
% the products by A = RW  and A' =W'*R' 
A = @(x) R(W(x));
AT = @(x) WT(RT(x));

% regularization parameter
if ~isfield(opts,'tau')  opts.tau=0.2; end %% regularization term scale
if ~isfield(opts,'Init')  opts.Init=AT(Bn); end %% regularization term scale
if ~isfield(opts,'MaxIter')  opts.MaxIter=100; end %% regularization term scale


% set tolA
tolA = 1.e-4;

% Run IST until the relative change in objective function is no
% larger than tolA
% [theta_ist,theta_debias,obj_IST,times_IST,debias_s,mses_IST]= ...
% 	 IST(y,A,tau,...
% 	'Debias',0,...
% 	'AT',AT,... 
%     'True_x',WT(f),...
% 	'Initialization',AT(y),...
% 	'StopCriterion',1,...
% 	'ToleranceA',tolA);

% Now, run the GPSR functions, until they reach the same value
% of objective function reached by IST.
[theta1,theta_debias1,obj_GPSR_Basic,times_GPSR_Basic,debias_s,mses_GPSR_Basic]= ...
	GPSR_Basic(Bn,A,opts.tau,...
	'Debias',0,...
	'AT',AT,...    
'MaxiterA',opts.MaxIter,...
 'Initialization', opts.Init,...
 'StopCriterion',4,...
	'ToleranceA',tolA,...
      'Verbose',0);


[theta2,theta_debias2,obj_QP_BB_mono,times_QP_BB_mono,debias_start,mses_QP_BB_mono]= ...
	GPSR_BB(Bn,A,opts.tau,...
	'AT', AT,...
	'Debias',0,...
	'Initialization', opts.Init,...
    'MaxiterA',opts.MaxIter,...
    'Monotone',1,...
	'StopCriterion',4,...
	'ToleranceA',tolA,...
      'Verbose',0);


if prod(size(theta_debias1))~=0
   u1=(W(theta_debias1));
else
   u1=(W(theta1));
end



if prod(size(theta_debias2))~=0
   u2=(W(theta_debias2));
else
   u2=(W(theta2));
end


