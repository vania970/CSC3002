function [ Features ] = rawpixel( Img )
%Preprocessing - returns raw pixel values of images

%Preallocate.
row = size(Img,3);
column = size(Img);
column = prod(column(1:2));
Features = zeros(row, column);

%Puts all pixels of an image into a vector
for i=1:size(Img, 3)
    Images = Img(:,:,i);
    Features(i,:) = Images(:);
end