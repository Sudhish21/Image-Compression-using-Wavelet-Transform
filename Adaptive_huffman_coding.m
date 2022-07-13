clear all; 
close all;
clc;
% Reading image
a=imread('lh.jpg'); 
imshow(a);
title("Original Image")
figure();

% Converting an image to grayscale
I=rgb2gray(a);
%Size of the image
[m,n]=size(I);
Totalcount=m*n;
% Variables using to find the probability 
cnt=1;
sigma=0;
% Computing the cumulative probability. 
for i=0:255
k=I==i;
count(cnt)=sum(k(:));
%Pro array is having the probabilities 
pro(cnt)=count(cnt)/Totalcount;
sigma=sigma+pro(cnt); 
cumpro(cnt)=sigma;
cnt=cnt+1; 
end
%Symbols for an image 
symbols = [0:255];
%Adaptive Huffman code Dictionary
dict = huffmandict(symbols,pro);
%Function which converts array to vector 
vec_size = 1;
for p = 1:m 
    for q = 1:n
        newvec(vec_size) = I(p,q); 
        vec_size = vec_size+1;
    end
end

% Adaptive Huffman Encoding
hcode = huffmanenco(newvec,dict);

% Adaptive Huffman Decoding
dhsig1 = huffmandeco(hcode,dict);

% Converting dhsig1 double to dhsig uint8 
dhsig = uint8(dhsig1);

% Vector to array conversion 
dec_row=sqrt(length(dhsig));
dec_col=dec_row;

% Variables using to convert vector 2 array 

arr_row = 1;
arr_col = 1;
vec_si = 1;

for x = 1:m 
    for y = 1:n
        back(x,y)=dhsig(vec_si);
        arr_col = arr_col+1;
        vec_si = vec_si + 1; 
    end
    arr_row = arr_row+1;
end

% Converting image from grayscale to rgb
[deco, map] = gray2ind(back,256);
RGB = ind2rgb(deco,map);
imwrite(RGB,'decoded.JPG');
imshow(RGB);
title("Decoded Image")
% End of the Adaptive Huffman coding