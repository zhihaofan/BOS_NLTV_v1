function [u, new_noise_sigma, lambda,err] = tikronov_optimal_lambda(f, psf, sigma,lambda)

F = fft2(f);
otf = psf2otf(psf,size(f));

new_noise_sigma = sigma;

[M,N]=size(f);
    for k = 0:M-1
            for j = 0:N-1
               % dev(k+1,j+1) = sin(pi*k/M)^2+sin(pi*j/N)^2;
               dev(k+1,j+1) = 1;
            end
        end

if nargin<4
    lm = 0.001;
    lM = 1;

    

    lambda = 0.5*(lm+lM);
    tm = F.*dev./(abs(otf).^2/lambda+dev);
    Dist = real(sum(sum(abs(tm).^2)))/prod(size(f))^2-sigma^2;
    u = f;
    
    k = 1;

    while abs(lM-lm)> 1e-4 
    
  %  err(k) = Dist;
    
        if Dist > 0
         lM = lambda;        
        else
         lm = lambda;
       end
    
        lambda = 0.5*(lm+lM);
      tm = F.*dev./(abs(otf).^2/lambda+dev);
    Dist = real(sum(sum(abs(tm).^2)))/prod(size(f))^2-sigma^2;

       k = k+1;

    end
end

%lambda = lambda/4;

inv_filter = (conj(otf))./ ((abs(otf).^2 ) + lambda*dev);
 u = ifft2(F.*inv_filter);
 
 u = real(u);

 residual = f - ifft2(u).*otf;
 err = sum(sum(residual.^2))/prod(size(f));
 %err= Dist;
 
 
 
Invfilt = real(ifft2(inv_filter));
%Invfilt = inv_filter;
new_noise_sigma = sigma*norm(Invfilt,'fro');
 
