clc
close all

% Reading the image
X=imread('lh.jpg');
M = X;
X=X(1:256,1:256);

% Applying Haar Wavelet Transform
[cA1,cH1,cV1,cD1] = dwt2(X,'haar');

re_ima1 = idwt2(cA1,cH1,cV1,cD1,'haar'); % Performs a single-level 2-D wavelet reconstruction
re_ima=uint8(re_ima1); % Convert to unsigned 8-bit integer
subplot(2,1,1);
imshow(M);
title('Input image');
subplot(2,1,2);
imshow(re_ima);
title('1-level reconstructed image');

% Multilevel 2-D wavelet decomposition
[C,S] = wavedec2(X,2,'haar'); 
A2 = wrcoef2('a',C,S,'haar',2); % Reconstruct single branch from 2-D wavelet coefficients
A1 = wrcoef2('a',C,S,'haar',1);
H1 = wrcoef2('h',C,S,'haar',1);
V1 = wrcoef2('v',C,S,'haar',1);
D1 = wrcoef2('d',C,S,'haar',1);
H2 = wrcoef2('h',C,S,'haar',2);
V2 = wrcoef2('v',C,S,'haar',2);
D2 = wrcoef2('d',C,S,'haar',2);
colormap(gray);

subplot(2,4,1);
image(wcodemat(A1,192)); % Extended pseudocolor matrix scaling.
title('Approximation A1')
subplot(2,4,2);
image(wcodemat(H1,192));
title('Horizontal Detail H1')
subplot(2,4,3);
image(wcodemat(V1,192));
title('Vertical Detail V1')
subplot(2,4,4);
image(wcodemat(D1,192));
title('Diagonal Detail D1')
subplot(2,4,5);
image(wcodemat(A2,192));
title('Approximation A2')
subplot(2,4,6);
image(wcodemat(H2,192));
title('Horizontal Detail H2')
subplot(2,4,7);
image(wcodemat(V2,192));
title('Vertical Detail V2')
subplot(2,4,8);
image(wcodemat(D2,192));
title('Diagonal Detail D2')
dec2d = [A2,A1,H1,V1,D1,H2,V2,D2];

re_ima1 = waverec2(C,S,'haar'); % Multilevel 2-D wavelet reconstruction.
re_ima=uint8(re_ima1);
figure;
subplot(2,1,1);
imshow(M);
title('Input image');
subplot(2,1,2);
imshow(re_ima);
title('2-level reconstructed image');

n=1;
X=imread('lh.jpg');
X=X(1:256,1:256);
X=double(X)-128;

[Lo_D,Hi_D,Lo_R,Hi_R] = wfilters('haar');
[c,s]=wavedec2(uint8(X),n,Lo_D,Hi_D);
disp('Decomposition vector of size 1*524288 is stored in c');
disp('Coressponding book keeeping matrix');
disp(s);
[thr,nkeep] = wdcbm2(uint8(dec2d),1.5,prod(s(1,:))); % Thresholds for wavelet 2-D using Birge-Massart strategy.
[THR,SORH,KEEPAPP,CRIT] = ddencmp('cmp','wp',uint8(X)); % Default values for de-noising or compression.
[XC,TREED,PERF0,PERFL2] = wpdencmp(X,SORH,2,'haar',CRIT,THR,KEEPAPP); % De-noising or compression using wavelet packets.

XC=double(X)+128;
XO=uint8(XC);
imshow(XO);

title('Output image');
[b1,b2]=size(XC);
imshow(XO)
title('output')
imwrite(XO,'output.jpg');