%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% >>>> IMAGEBOX >>>> JX >>>> UCLA >>>>
%%
%% image toolbox
%% MATLAB file
%%
%% noiseadd.m
%% Add noise to image/matrix. mean zero.
%%
%% function f = noiseadd(eu, sigma, uni)
%% input:
%%     eu :   original data
%%     sigma: L2-norm of added noise.
%%     uni:   uniform noise? if this is set, then use uniform noise,
%%            otherwise use Gaussian noise.
%%
%% created:       07/27/2005
%% last modified: 07/27/2005
%% author:        jjxu@ucla
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function f = noiseadd(eu, sigma, uni)

if exist('uni') == 1 & uni ~= 0,  %% uniform noise
    ns = rand(size(eu));
else  %% Gaussian noise
    ns = randn(size(eu));
end;

%% normalization
ns = ns - mean(mean(ns));
sig = sqrt(sum(sum(ns.*ns))/(size(ns,1)*size(ns,2)));

%% add noise to generate noisy image
f = eu + sigma/sig * ns;

return;

%% end of the file
