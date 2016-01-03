%Signal to noise ratio

function SNR=SNR(u0,u)
%  u0: orginal image
%  u: noised image
%  (nb,na): size 
if size(u0)~=size(u)
    disp('They are not the same size')
    exit
end

[nb,na]=size(u0);
MSE=norm(abs(u-u0),'fro')^2/(nb*na);
SNR=10.*log10(var(u0(:))/MSE);

return
