function image2eps(I,image_name,dir,gmin, gmax)
if(nargin<4)
    gmin=min(I(:));
end
if(nargin<5)
    gmax=max(I(:));
end

f_name=fullfile([pwd, dir],image_name);
figure,imshow(I,[gmin,gmax ])
f1=gcf;
fhandle=['-f',num2str(f1)];
print (fhandle,'-depsc', f_name);