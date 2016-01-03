
global n


Jmax=log2(n);

nlev=num2str(Jmax);


%%load scaling


nom=['phi_hat' nlev];

loadpath=strcat('level',nlev,'/',nom);


load(loadpath,'phi_hat');



%%load horizontal 

nom=['psy_HOR_fft' nlev];

loadpath=strcat('level',nlev,'/',nom);

load(loadpath,'psy_HOR_fft');


%%load vertical

nom=['psy_VER_fft' nlev];
loadpath=strcat('level',nlev,'/',nom);

load(loadpath,'psy_VER_fft');



%%load diagonal

nom=['psy_DIA_fft' nlev];
loadpath=strcat('level',nlev,'/',nom);

load(loadpath,'psy_DIA_fft');

%disp('You have loaded the FFT2 Meyer transform(s)')
%disp('Maximum resolution level=')
%disp(Jmax)
clear nom nlev loadpath




