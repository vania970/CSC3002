function [features] = hog(Img)

features = zeros(size(Img,3), 900);

for i=1:size(Img, 3)
    features(i,:) =  extractHOGFeatures(Img(:,:,i));
end