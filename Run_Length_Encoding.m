% Matlab code for Image Compression Using Run Length Encoding
clc;
clear;  
close all;

% Set Quantization Parameter
quantizedvalue=10;

% Read Input Image
I=imread('lh.jpg');
[row, col, p]=size(I);

% Wavelet Decomposition 
[LL, LH, HL, HH] = dwt2(I,'haar'); % Single-level discrete 2-D wavelet transform.
WaveletDecomposeImage = [LL,LH;HL,HH]; 
WaveletDecomposeImage1 = [LH,HL,HH]; 
imshow(WaveletDecomposeImage1,[]);
title("Decomposed Images");
figure();

% Uniform quantization
QuantizedImage= WaveletDecomposeImage/quantizedvalue;
QuantizedImage= round(QuantizedImage);

% Convert the two dimensional image to a one dimensional Array using ZigZag scanning
ImageArray=toZigzag(QuantizedImage);

imshow(I);
title('Original image');
figure();

level=graythresh(I);
bw=im2bw(I,level); % Convert image to binary image by thresholding
a=bw'; 
a=a(:); 
a=a';
a=double(a);
rle(1)=a(1); 
m=2; 
rle(m)=1;

for i=1:length(a)-1
    if a(i)==a(i+1)
        rle(m)=rle(m)+1;
    else
        m=m+1; rle(m)=1;        %Dynamic allocation and initialization of next element of rle
    end
end
%display(rle);

imwrite(bw,'Output.jpg');
imshow(bw);
title("Output Image");

%The program will return RUN LENGTH ENCODED (row)martix
function d=toZigzag(A)
 d=[];
    n=length(A);
    w=1;
    for i=1:n
      C=A(1:i,1:i);
      if w==1
        d=[d diag(flipud(C))'];
        w=0;
      else
        d=[d diag(flipud(C'))'];
        w=1;
      end
    end
    for i=2:n
      C=A(i:n,i:n);
      if w==1
        d=[d diag(flipud(C))'];
        w=0;
      else
        d=[d diag(flipud(C'))'];
        w=1;
      end
    end
end