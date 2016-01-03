% mrdwt_cycle2D.m
%
% Same as mrdwt(), just returns the results in a nicer matrix (indexed
% correctly for these tree algorithms).
% Usuage : [yw, ys] = mrdwt_cycle2D(x, h, L)
% yw - wavelet coefficients.  NxNxLx3.
% ys - scaling coefficients.  NxN.
%
% Written by : Justin Romberg
% Created : 3/15/99

function [yw,ys] = mrdwt_cycle2D(x, h, L)

[ys,yh] = mrdwt(x, h, L);
N = size(x,1);
yw = zeros(N,N,L,3);

for ll = 1:L
  yw(:,:,L-ll+1,2) = ...
      flipud(fliplr(cshift2(yh(:,(ll-1)*N*3+1:(ll-1)*N*3+N),-1,-1)))';
  yw(:,:,L-ll+1,1) = ...
      flipud(fliplr(cshift2(yh(:,(ll-1)*N*3+N+1:(ll-1)*N*3+2*N),-1,-1)))';
  yw(:,:,L-ll+1,3) = ...
      flipud(fliplr(cshift2(yh(:,(ll-1)*N*3+2*N+1:ll*N*3),-1,-1)))';
% $$$   yw(:,:,L-ll+1,2) = ...
% $$$       cshift2(flipud(fliplr(yh(:,(ll-1)*N*3+1:(ll-1)*N*3+N))),1,1)';
% $$$   yw(:,:,L-ll+1,1) = ...
% $$$       cshift2(flipud(fliplr(yh(:,(ll-1)*N*3+N+1:(ll-1)*N*3+2*N))),1,1)';
% $$$   yw(:,:,L-ll+1,3) = ...
% $$$       cshift2(flipud(fliplr(yh(:,(ll-1)*N*3+2*N+1:ll*N*3))),1,1)';

  
end
