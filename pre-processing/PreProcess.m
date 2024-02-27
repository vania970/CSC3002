function [ Img ] = PreProcess( Img )
%Preprocesses images before being used in Models
%Using Histogram Equalisation

for i=1:size(Img,3)
    Img(:,:,i) = histeq(Img(:,:,i));
    imshow(Img(:,:,i));
end