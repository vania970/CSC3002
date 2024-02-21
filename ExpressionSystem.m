function [ tP, tN, fP, fN ] = ExpressionSystem(FDOptions, COptions, crossVal, resultsFolder)
addpath ./functions
addpath ./Data
addpath ./pre-processing
addpath ./SVM
addpath ./KNN

%% Setup


% Get the training set.
[TrainingImages, TrainingLabels] = getTrainingSet('Data/images/train/');

% Preprocess
ProcessedTrainingImages =  TrainingImages; %PreProcess(TrainingImages);

save([resultsFolder 'TrainingImages.mat'], 'TrainingImages', 'TrainingLabels', 'ProcessedTrainingImages');
Loss = 'N/A';

%% Feature Descriptor
fdMethod = FDOptions(1);
switch fdMethod{:}
    case 'fullimage'
        TrainingFeatures = rawpixel(ProcessedTrainingImages);
        featureDescriptorFunc0 = @(X) rawpixel(X);
    case 'hog'
        TrainingFeatures = hog(ProcessedTrainingImages);
        featureDescriptorFunc0 = @(X) hog(X);
end

if(size(FDOptions, 2) > 1)
    param = FDOptions(2);
    switch param{:}
        case 'pca'
            [TrainingFeatures, eigenVectors] = PCA(TrainingFeatures);
            featureDescriptorFunc = @(X) PCAReduce(eigenVectors, featureDescriptorFunc0(X));
    end
else
    featureDescriptorFunc = featureDescriptorFunc0;
end

save([resultsFolder 'TrainingFeatures.mat'], 'TrainingFeatures');

%% Training

classifierMethod = COptions(1);
switch classifierMethod{:}
    
    case 'KNN'
        if(size(COptions, 2) > 1)
            k = COptions(2);
            k = k{:};
        else
            k = 100;
        end
        
        Model = TrainingFeatures;
        
        if(crossVal)
            cvModel = fitcknn(TrainingFeatures, TrainingLabels, 'CrossVal', 'on', 'NumNeighbors', k); 
            Loss = kfoldLoss(cvModel);
        end
             
        validationMethod = @(X) KNNTest(Model, TrainingLabels, X, k);
    
    case 'SVM'
        Model = SVMTraining(TrainingFeatures, TrainingLabels);
        validationMethod = @(X) SVMTesting(Model, X);
        
        if(crossVal)
            cvModel = crossval(Model);
            Loss = kfoldLoss(cvModel);
        end
end
disp(['Loss: ' num2str(Loss)]);

save([resultsFolder 'Model.mat'], 'Model', 'Loss');

%% Testing
TestImages = getImages('Data/images/validation/angry/');
GreyTestImages = uint8(zeros(48, 48, size(TestImages, 4)));
for i=1:size(GreyTestImages, 3)
    GreyTestImages(:,:,i) = rgb2gray(TestImages(:,:,:,i));
end
% TestImagesLabels = ones(size(TestImages,4),1);
% TestAnswers = parseTestAnswers(TestImagesLabels);
% save([resultsFolder 'TestAnswers.mat'], 'TestAnswers');

ProcessedTestImages = PreProcess(GreyTestImages);

save([resultsFolder 'TestImages.mat'], 'TestImages', 'ProcessedTestImages');

%True positive,true negative, false postive, false negative
tP = zeros(size(ProcessedTestImages,3),1);
tN = zeros(size(ProcessedTestImages,3),1);
fP = zeros(size(ProcessedTestImages,3),1);
fN = zeros(size(ProcessedTestImages,3),1);

end