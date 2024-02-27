function [model] = SVMTraining(features, labels)

%labels that are -1 or 1 for the binary problem(pos/neg)
labels(labels==0)=-1;

model = fitcsvm(features, labels,'KernelFunction','linear','ClassNames',[-1,1], 'Standardize', true,'BoxConstraint', 0.1);

model = fitSVMPosterior(model);



end