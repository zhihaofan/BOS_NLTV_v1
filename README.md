# BOS_NLTV_v1
非局部相似性
function wopts=update_weight(Im0,h0,nwin,nbloc,NbBestNeigh)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Im0 是原图（高清）进过降质，然后双三次插值到放大倍数的图片
 hr_im     =   imresize( lr_im, par.scale, 'bicubic' );
  par.LR        =    Add_noise(LR, par.nSig);

%% h0  在opt_init.m中初始化 滤波器的权重 取决于噪声和图像标准差
if ~isfield(opts,'h0' )  opts.h0=20; end %% weight filter parater, depends on noise and image standard variation. for example: for barbara [0, 255], h0=20; To be adapted for normalized image

%% nwin 在opt_init.m中初始化
if ~isfield(opts,'nWin' ) opts.nWin=2;  end    %% patch size [2*nwin+1, 2*nwin+1]

%% nbloc 在opt_init.m中初始化
if ~isfield(opts,'nBloc' ) opts.nBloc=10; end   %% search window size [2*bloc+1, 2*bloc+1]

%% NbBestNeigh 在update_weight.m中初始化
if (~exist('NbBestNeigh' ,'var' ))
NbBestNeigh = 21; % >=6
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

这些参数表示的意义是什么？
计算非局部相似性返回的参数：
