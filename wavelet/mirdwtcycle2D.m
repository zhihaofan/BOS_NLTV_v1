% mirdwt_cycle2D.m
%
% Inverts mrdwt_cycle2D().
% Usuage : x = mirdwt_cycle2D(yw, ys, h, L)
% yw - wavelet coefficients NxNxLx3
% ys - scaling coefficients NxN
% x - output signal NxN
%
% Written by : Justin Romberg
% Created : 3/21/99

function x = mirdwt_cycle2D(yw, ys, h, L);

N = size(yw,1);

yh = zeros(N,L*N*3);
for ll = 1:L
  %keyboard
  yh(:,(ll-1)*N*3+1:(ll-1)*N*3+N) = ...
      cshift2(fliplr(flipud(yw(:,:,L-ll+1,2)')),1,1);
  yh(:,(ll-1)*N*3+N+1:(ll-1)*N*3+2*N) = ...
      cshift2(fliplr(flipud(yw(:,:,L-ll+1,1)')),1,1);
  yh(:,(ll-1)*N*3+2*N+1:ll*N*3) = ...
      cshift2(fliplr(flipud(yw(:,:,L-ll+1,3)')),1,1);
end

x = mirdwt(ys, yh, h, L);