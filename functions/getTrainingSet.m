function [ Images,Labels ] = getTrainingSet( dir )

%Get the images and labels.
trainingImagesAngry = getImages([dir 'angry/']);
trainingImageLabelsAngry = ones(size(trainingImagesAngry,4),1);

% trainingImagesDisgust = getImages([dir 'disgust/']);
% trainingImageLabelsDisgust = 2*ones(size(trainingImagesDisgust,4),1);
% 
% trainingImagesFear = getImages([dir 'fear/']);
% trainingImageLabelsFear = 3*ones(size(trainingImagesFear,4),1);
% 
% trainingImagesSad = getImages([dir 'sad/']);
% trainingImageLabelsSad = 4*ones(size(trainingImagesSad,4),1);
% 
% trainingImagesSurprise = getImages([dir 'surprise/']);
% trainingImageLabelsSurprise = 5*ones(size(trainingImagesSurprise,4),1);
% 
% trainingImagesNeutral = getImages([dir 'neutral/']);
% trainingImageLabelsNeutral = zeros(size(trainingImagesNeutral,4),1);

trainingImagesHappy = getImages([dir 'happy/']);
trainingImageLabelsHappy = -1*zeros(size(trainingImagesHappy,4),1);

grayImagesAngry = uint8(zeros(48,48,size(trainingImagesAngry,4)));
for i=1:size(trainingImagesAngry,4)
    grayImagesAngry(:,:,i) = rgb2gray(trainingImagesAngry(:,:,:,i));
end

% grayImagesDisgust = uint8(zeros(48,48,size(trainingImagesDisgust,4)));
% for i=1:size(trainingImagesDisgust,4)
%     grayImagesDisgust(:,:,i) = rgb2gray(trainingImagesDisgust(:,:,:,i));
% end
% 
% grayImagesFear = uint8(zeros(48,48,size(trainingImagesFear,4)));
% for i=1:size(trainingImagesFear,4)
%     grayImagesFear(:,:,i) = rgb2gray(trainingImagesFear(:,:,:,i));
% end
% 
% grayImagesSad = uint8(zeros(48,48,size(trainingImagesSad,4)));
% for i=1:size(trainingImagesSad,4)
%     grayImagesSad(:,:,i) = rgb2gray(trainingImagesSad(:,:,:,i));
% end
% 
% grayImagesSurprise = uint8(zeros(48,48,size(trainingImagesSurprise,4)));
% for i=1:size(trainingImagesSurprise,4)
%     grayImagesSurprise(:,:,i) = rgb2gray(trainingImagesSurprise(:,:,:,i));
% end
% 
% grayImagesNeutral = uint8(zeros(48,48,size(trainingImagesNeutral,4)));
% for i=1:size(trainingImagesNeutral,4)
%     grayImagesNeutral(:,:,i) = rgb2gray(trainingImagesNeutral(:,:,:,i));
% end

grayImagesHappy = uint8(zeros(48,48,size(trainingImagesHappy,4)));
for i=1:size(trainingImagesHappy,4)
    grayImagesHappy(:,:,i) = rgb2gray(trainingImagesHappy(:,:,:,i));
end
    
% Concatenate both positive and negative examples.
% Images = cat(3, grayImagesAngry, grayImagesDisgust, grayImagesFear, grayImagesSad, grayImagesSurprise, grayImagesNeutral, grayImagesHappy);
% Labels = cat(1, trainingImageLabelsAngry, trainingImageLabelsDisgust, trainingImageLabelsFear, trainingImageLabelsSad, trainingImageLabelsSurprise, trainingImageLabelsNeutral, trainingImageLabelsHappy);

Images = cat(3, grayImagesAngry, grayImagesHappy);
Labels = cat(1, trainingImageLabelsAngry, trainingImageLabelsHappy);

% Randomise the order.
permutation = randperm(size(Images,3));
Images = Images(:,:,permutation);
Labels = Labels(permutation);

end