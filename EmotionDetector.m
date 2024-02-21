clear all;
close all;
% Machine Learning Method (classifier) options: {'KNN'}, {'SVM'}
% Feature Descriptor Options: {'fullimage'} , {'hog'}, {'fullimage' , 'pca'}, {'hog', 'pca'}

% Start timer before every process to calculate computing time
tic

% Create a file to store our results
resultsFolder = strrep(datestr(datetime), ' ', '_');
resultsFolder = strrep(resultsFolder, ':', '-');
resultsFolder = ['results/' resultsFolder '/'];
mkdir(resultsFolder);
mkdir([resultsFolder 'images/']);

% Configure what model and Extraction to use
ExtractionOption = {'fullimage'};
ModelType = {'KNN'};
CrossValidation = true;

save([resultsFolder 'Options.mat'], 'ExtractionOption', 'ModelType');

% === Get images from live cam ===
% delete(imaqfind)
% vid = videoinput('winvideo', 1);
% triggerconfig(vid, 'manual');
% set(vid, 'FramesPerTrigger', 1);
% set(vid, 'TriggerRepeat', Inf);
% 
% % View the default colour space used for the data
% colour_spec=vid.ReturnedColorSpace;
% % Modify colour space used for the data
% if ~strcmp(colour_spec,'rgb')
%     set(vid,'ReturnedColorSpace','rgb');
% end
% 
% start(vid)
% faceDetector = vision.CascadeObjectDetector;
% 
% for ii = 1:600
%     trigger(vid);
%     img=getdata(vid,1); % Get the frame in webcam
%     imshow(img)
% 
%     % Detect Faces
%     bbox = step(faceDetector, img);
% 
%     if ~isempty(bbox)
%         bbox=bbox(1,:);
%         rectangle('Position',bbox,'edgecolor','b','LineWidth',5);
%         FaceCropped = imcrop(img,bbox);
%         Face_Resized = imresize(FaceCropped, [64 64]);
%         net= alexnet;
%         %[YPred, probs]=classify(net,Face_Resized);
%         [ tPos, tNeg, fPos, fNeg ] = ExpressionSystem( ExtractionOption, ModelType, CrossValidation, resultsFolder, Face_Resized);
%         position=[0 0;];
%         box_colour={'red'};
%         a=nominal(YPred);
%         pred_str=cellstr(a);
%         RGB=insertText(img,position,pred_str,'FontSize',45,'BoxColor',...
%            box_colour,'BoxOpacity',1,'TextColor','Black');
%         figure,imshow(RGB)
%         rectangle('Position',bbox,'edgeColor','b','LineWidth',5);
%     end
% 
% end

% Run the full training / testing.
[ tPos, tNeg, fPos, fNeg ] = ExpressionSystem( ExtractionOption, ModelType, CrossValidation, resultsFolder);

% Sum of the results
TP = sum(tPos);
TN = sum(tNeg);
FP = sum(fPos);
FN = sum(fNeg);

N = TP + TN + FP + FN;

accuracy = (TN + TP) / N
errorRate = (FN + FP) / N;
recall = TP / (TP +FN);
precision = TP / (TP+FP);
specificity = TN / (TN+FP);
f1 = 2*TP / (2*TP + FN + FP);
falseAlarmRate = FP / (FP+TN);

save([resultsFolder 'Metrics.mat'], ...
    'tPos', 'tNeg', 'fPos', 'fNeg', ...
    'TP', 'TN', 'FP', 'FN', 'N', ...
    'accuracy', 'errorRate', ...
    'recall', 'precision', ...
    'specificity', 'f1', ...
    'falseAlarmRate');

% Finish the timer to get elapsed time
toc