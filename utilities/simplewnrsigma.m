function [J, sigma1]=simplewnrsigma(I,psf,sigma,regparam)
if nargin<4
regparam = 0.001;
end

[ny,nx]=size(I);
H = psf2otf(psf, [ny,nx]);

RegInvfilter = (conj(H)) ./ ((abs(H).^2 ) + regparam);
J= real(ifft2(RegInvfilter .* fft2(I)));

if nargout>1
Invfilt = real(ifft2(RegInvfilter));
cx=floor(nx/2)+1;
cy=floor(ny/2)+1;

Invfilt = circshift(Invfilt,[-cx -cy]);
sigma1=sigma*norm(Invfilt,'fro');
end
