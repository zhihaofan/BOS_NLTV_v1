function PSNR=PSNR(u0,u,uni)
%  u0: orginal image
%  u: noised image
%  (nb,na): size 
% generalize to image sequence

if nargin<3
    uni=0;
end

if ndims(u)<ndims(u0)
 error ('Dimesion of second one should be larger or equal to the dimension of the first one');
end

if (uni)
   min_=0;
   max_=255;
   
else
max_=max(max(u0));
min_=min(min(u0));
end
[nb na]=size(u0);

if ndims(u)==2 % They are images
if size(u0)~=size(u)
    error ('Sizes of the two images are not equal');
end
MSE=norm(abs(u-u0),'fro')^2/(nb*na);
PSNR=10.*log10((max_-min_)^2/MSE);
else % second one is an image sequence
   PSNR=zeros(size(u,3),1);
   for i=1:size(u,3)
MSE=norm(abs(u(:,:,i)-u0),'fro')^2/(nb*na);
PSNR(i)=10.*log10((max_-min_)^2/MSE);
   end
end