function  u= image_rescale(u,gmin,gmax)
if nargin<2
    gmin = 0.;
end
if nargin<3
    gmax = 1.;
end

m = min(u(:));
M = max(u(:));

if M>m
    u = (gmax-gmin) * (u-m)/(M-m) + gmin;
end

